// Dart imports:
import 'dart:developer' as dev;

// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/core/network/connectivity_handler.dart';
import 'package:tomza_kit/utils/notifier.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/model/request/login_admin_request.dart';
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/routes/route_paths.dart';

class LoginAdminLogic extends ChangeNotifier {
  LoginAdminLogic({required this._repository}) {
    loadVersion();
  }

  final Repository _repository;

  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final int _shakeTick = 0;
  int get shakeTick => _shakeTick;

  final bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;
  bool _isLoginLoading = false;
  bool get isLoginLoading => _isLoginLoading;

  String _version = '';
  String get version => _version;

  Future<String> loadVersion() async {
    _version = '2.0.0';
    notifyListeners();
    return _version;
    // return _version = await AppVersion.displayVersion();
  }

  Future<void> loginAdmin(BuildContext context) async {
    setLoading(true);

    if (!await ConnectivityHandler.hasExcellentSignal()) {
      showError(
        'Señal débil o inestable. Para ingresar debe tener una señal excelente',
      );
      setLoading(false);
      return;
    }

    if (userController.text.isEmpty && passwordController.text.isEmpty) {
      showError('Usuario y contraseña son requeridos');
      setLoading(false);
      return;
    }

    try {
      final request = LoginAdminRequest(
        user: userController.text.toUpperCase().trim(),
        password: passwordController.text.toUpperCase().trim(),
      );
      final r = await _repository.loginAdmin(request);
      setLoading(false);

      if (r.status != 1) {
        showError('Usuario o contraseña incorrectos');
        return;
      } else {
        if (context.mounted) {
          await Navigator.pushNamed(context, RoutePaths.imei);
        }
      }
    } catch (e) {
      setLoading(false);
      dev.log('Error al iniciar: $e');
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void setLoading(bool value) {
    _isLoginLoading = value;
    notifyListeners();
  }
}
