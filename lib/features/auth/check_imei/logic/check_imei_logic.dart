// Dart imports:
import 'dart:developer' as dev;
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/core/enum/dialog_type.dart';
import 'package:tomza_kit/core/network/connectivity_handler.dart';
import 'package:tomza_kit/core/network/network_exceptions.dart';
import 'package:tomza_kit/utils/notifier.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/model/request/valid_imei_request.dart';
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/routes/route_paths.dart';
import 'package:app_supervisores_gt/core/storage/shared_preferences_helper.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';

typedef ShowDialogCallback = void Function(
  String title,
  String message,
  DialogType type, {
  VoidCallback? onAccept,
});

class CheckImeiLogic extends ChangeNotifier implements TickerProvider {
  CheckImeiLogic({required this._repository, DeviceInfoPlugin? deviceInfo})
    : _deviceInfo = deviceInfo ?? DeviceInfoPlugin() {
    _setupAnimations();
    _validateImei();
  }

  final Repository _repository;
  final DeviceInfoPlugin _deviceInfo;

  bool _isRegistered = false;
  bool get isRegistered => _isRegistered;
  bool _hasNavigated = false;

  bool _isValidImei = false;
  bool get isValidImei => _isValidImei;

  late AnimationController pulseController;
  late AnimationController rotationController;
  late Animation<double> pulseAnimation;
  late Animation<double> rotationAnimation;

  void _setupAnimations() {
    // Animación de pulso para el ícono
    pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );

    // Animación de rotación para el indicador de carga
    rotationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(rotationController);

    // Iniciar animaciones
    pulseController.repeat(reverse: true);
    rotationController.repeat();
  }

  @override
  Ticker createTicker(TickerCallback onTick) =>
      Ticker(onTick, debugLabel: kDebugMode ? 'created by $this' : null);

  @override
  void dispose() {
    pulseController.dispose();
    rotationController.dispose();
    super.dispose();
  }

  // Callback para navegación directa
  Function(String)? _onNavigate;
  // Callback simple (existente) sin acción al aceptar
  Function(String, String, DialogType)? _onShowDialog;
  // Nuevo callback opcional con onAccept para navegación diferida
  ShowDialogCallback? _onShowDialogWithAction;

  void setCallbacks({
    Function(String)? onNavigate,
    Function(String, String, DialogType)? onShowDialog,
    ShowDialogCallback? onShowDialogWithAction,
  }) {
    _onNavigate = onNavigate;
    _onShowDialog = onShowDialog;
    _onShowDialogWithAction = onShowDialogWithAction;

    // Si ya terminó la validación y aún no hemos navegado, disparar ahora
    if (_isValidImei && !_hasNavigated && _onNavigate != null) {
      _navigateNext(_isRegistered);
    }
  }

  Future<void> _validateImei() async {
    setLoading(false);
    notifyListeners();
    try {
      final helper = sl<SharedPreferencesHelper>();
      final previouslyValidated = await helper.isImeiValidatedOnce();

      // Intentar recuperar un IMEI manual guardado (excepción de negocio)
      String? identifier = await helper.getManualImei();
      // Si no existe, usar un identificador de dispositivo permitido (androidId)
      if (identifier == null || identifier.isEmpty) {
        if (Platform.isAndroid) {
          final AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
          // id es no-null en versiones recientes del plugin; usarlo.
          identifier = androidInfo.id;
        } else if (Platform.isIOS) {
          final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
          // identifierForVendor es el ID recomendado en iOS.
          identifier = iosInfo.identifierForVendor;
        } else {
          identifier = '';
        }
      }

      String finalId = identifier ?? '';
      if (finalId.isEmpty) {
        finalId = await helper.getOrCreateFallbackDeviceId();
      }
      dev.log('Identificador usado para validación: $finalId');

      if (previouslyValidated) {
        setLoading(true);
        _navigateNext(true);
        notifyListeners();
        return;
      }

      if (!await ConnectivityHandler.hasExcellentSignal()) {
        showError(
          'Señal débil o inestable. Para ingresar debe tener una señal excelente',
        );
        setLoading(false);
        return;
      }

      await _checkDeviceRegistration(finalId);
    } on PlatformException {
      final UnexpectedAppException fail = UnexpectedAppException(
        'No se pudo obtener el ID del dispositivo. Verifique permisos.',
      );
      setLoading(false);
      if (_onShowDialogWithAction != null) {
        _onShowDialogWithAction!('Error', fail.message ?? '', DialogType.error);
      } else {
        _onShowDialog?.call('Error', fail.message ?? '', DialogType.error);
      }
      notifyListeners();
    } catch (e) {
      final UnexpectedAppException fail = UnexpectedAppException(
        'Error inesperado al obtener el ID: $e',
      );
      setLoading(false);
      if (_onShowDialogWithAction != null) {
        _onShowDialogWithAction!('Error', fail.message ?? '', DialogType.error);
      } else {
        _onShowDialog?.call('Error', fail.message ?? '', DialogType.error);
      }
      notifyListeners();
    }
  }

  Future<void> _checkDeviceRegistration(String imei) async {
    setLoading(true);
    try {
      final result = await _repository.validImei(ValidImeiRequest(imei: imei));

      setLoading(false);
      // Cualquier respuesta 200 implica IMEI registrado.
      // Ignoramos resp.isRegistered para evitar depender del campo.
      if (result.status != 1 && result.isRegister == false) {
        showError('IMEI no registrado');
        throw Exception(result.message);
      }
      final helper = sl<SharedPreferencesHelper>();
      await helper.setImeiValidatedOnce(true);
      await helper.saveLastValidatedImei(imei);
      await _navigateNext(result.isRegister);
      notifyListeners();
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
      _navigateNext(false);
      notifyListeners();
      /* if (_onShowDialogWithAction != null) {
        _onShowDialogWithAction!(
          'IMEI no registrado',
          e.message,
          DialogType.error,
          onAccept: () => _navigateNext(false),
        );
      } else {
        _onShowDialog?.call(
          'IMEI no registrado',
          e.message,
          DialogType.error,
        );
      } */
    }
  }

  /// Navega a la ruta correspondiente según esté registrado o no.
  Future<void> _navigateNext(bool registered) async {
    if (_onNavigate == null) {
      return;
    }
    if (_hasNavigated) return;
    _hasNavigated = true;
    _isRegistered = registered;
    final String nextRoute = registered
        ? RoutePaths.loginUser
        : RoutePaths.loginAdmin;
    dev.log('CheckImeiBloc: Navigating to $nextRoute');
    await _onNavigate?.call(nextRoute);
  }

  Future<void> refresh() => _validateImei();

  void setLoading(bool value) {
    _isValidImei = value;
  }
}
