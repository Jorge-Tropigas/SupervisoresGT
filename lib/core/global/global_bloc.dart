// Dart imports:
import 'dart:convert';
import 'dart:typed_data';

// Package imports:
import 'package:geolocator/geolocator.dart';
import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomza_kit/core/location/gps_service.dart';
import 'package:tomza_kit/utils/notifier.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/model/response/login_user_response.dart';
import 'package:app_supervisores_gt/core/storage/shared_preferences_helper.dart';
import 'package:app_supervisores_gt/features/auth/login_user/model/user.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';

class GlobalBloc extends ChangeNotifier {
  GlobalBloc({required this._user, required this._gps});

  final AppLocationService _gps;
  User _user;
  User get currentUser => _user;

  double? _initialLatitude;
  double? _initialLongitude;
  DateTime? _initialLocationTimestamp;
  double? get initialLatitude => _initialLatitude;
  double? get initialLongitude => _initialLongitude;
  DateTime? get initialLocationTimestamp => _initialLocationTimestamp;
  Position? currentPosition;

  double? _mapTargetLat;
  double? _mapTargetLng;
  String? _mapTargetLabel;
  double? get mapTargetLat => _mapTargetLat;
  double? get mapTargetLng => _mapTargetLng;
  String? get mapTargetLabel => _mapTargetLabel;

  // ==================================================
  // CONSTANTES DE PERSISTENCIA
  // ==================================================
  static const String _kInitialLatKey = 'initial_lat';
  static const String _kInitialLngKey = 'initial_lng';
  static const String _kInitialLocTsKey = 'initial_loc_ts';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> startLocationStream() async {
    await _gps.startStream(
      onPosition: (position) {
        currentPosition = position;
        notifyListeners();
      },
    );
  }

  Future<void> captureInitialLocation({bool force = false}) async {
    if (!force && _initialLatitude != null && _initialLongitude != null) {
      return;
    }
    final PermissionStatus permission = await Permission.locationWhenInUse
        .request();
    if (!permission.isGranted) {
      return;
    }
    try {
      final pos = await _gps.getCurrentPositionDetail(
        timeLimit: const Duration(seconds: 10),
      );
      if (pos == null) return;
      _initialLatitude = pos.latitude;
      _initialLongitude = pos.longitude;
      _initialLocationTimestamp = DateTime.now();
      await _persistInitialLocation();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _persistInitialLocation() async {
    if (_initialLatitude == null || _initialLongitude == null) {
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_kInitialLatKey, _initialLatitude!);
      await prefs.setDouble(_kInitialLngKey, _initialLongitude!);
      if (_initialLocationTimestamp != null) {
        await prefs.setString(
          _kInitialLocTsKey,
          _initialLocationTimestamp!.toIso8601String(),
        );
      }
    } catch (_) {}
  }

  Future<void> initLocation(BuildContext context) async {
    try {
      final status = await _gps.checkAndRequestPermission();
      if (status == GpsStatus.serviceDisabled) {
        showInfo('Servicio de ubicación deshabilitado');
        notifyListeners();
        return;
      }
      if (status == GpsStatus.permissionDenied) {
        showInfo('Permiso de ubicación denegado');
        notifyListeners();
        return;
      }
      if (status == GpsStatus.permissionDeniedForever) {
        showInfo('Permiso de ubicación denegado permanentemente');
        notifyListeners();
        return;
      }
      currentPosition = await _gps.getCurrentPositionDetail(
        timeLimit: const Duration(seconds: 10),
      );
      if (currentPosition != null &&
          (_initialLatitude == null || _initialLongitude == null)) {
        _initialLatitude = currentPosition!.latitude;
        _initialLongitude = currentPosition!.longitude;
        _initialLocationTimestamp = DateTime.now();
        await _persistInitialLocation();
      }
      startLocationStream();
      notifyListeners();
    } on Exception catch (e) {
      showInfo('Error obteniendo ubicación: $e');
    }
  }

  Map<String, double>? get currentPositionJson => currentPosition == null
      ? null
      : <String, double>{
          'latitude': currentPosition!.latitude,
          'longitude': currentPosition!.longitude,
        };

  void setMapTarget({required double lat, required double lng, String? label}) {
    _mapTargetLat = lat;
    _mapTargetLng = lng;
    _mapTargetLabel = label;
    notifyListeners();
  }

  double? distanceTo(double targetLat, double targetLng) {
    if (currentPosition == null) {
      return null;
    }
    return _gps.distanceBetween(
      currentPosition!.latitude,
      currentPosition!.longitude,
      targetLat,
      targetLng,
    );
  }

  bool validateProximity(
    BuildContext context, {
    required double targetLat,
    required double targetLng,
    double maxMeters = 50,
  }) {
    final double? dist = distanceTo(targetLat, targetLng);
    if (dist == null) {
      showInfo(
        'Ubicación no disponible: No se pudo obtener tu ubicación actual. Activa el GPS y vuelve a intentar.',
      );
      return false;
    }
    if (dist >= maxMeters) {
      showInfo(
        'Fuera de rango: Estás a ${dist.toStringAsFixed(1)} m del punto. Máximo permitido ${maxMeters.toStringAsFixed(0)} m.',
      );
      return false;
    }
    return true;
  }

  /// Decodifica cadenas base64 (con o sin prefijo data:) a bytes de PDF.
  Uint8List? decodeBase64Pdf(String source) {
    try {
      if (source.trim().isEmpty) {
        return null;
      }
      // Soporta formatos con prefijo: data:application/pdf;base64,xxxx
      final int idx = source.indexOf(',');
      final String b64 = source.contains('base64') && idx != -1
          ? source.substring(idx + 1)
          : source;
      return base64.decode(b64);
    } catch (_) {
      return null;
    }
  }

  List<Uint8List?> decodeBase64Pdfs(List<String>? sources) {
    try {
      if (sources == null || sources.isEmpty) {
        return [];
      }
      return sources.map((source) => decodeBase64Pdf(source)).toList();
    } catch (_) {
      return [];
    }
  }

  void updateUser(User newUser, {bool notify = true}) {
    _user = newUser;
    notifyListeners();
  }

  Future<void> saveSession(LoginUserResponse response) async {
    // Guardado centralizado usando helper (JSON completo del usuario)
    final SharedPreferencesHelper helper = sl<SharedPreferencesHelper>();
    _user = response.user;
    await helper.saveUser(_user);
    if (sl.isRegistered<User>()) {
      sl.unregister<User>();
    }
    sl.registerLazySingleton<User>(() => currentUser);
    if (sl.isRegistered<GlobalBloc>()) {
      try {
        sl<GlobalBloc>().updateUser(currentUser, notify: false);
      } catch (_) {}
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _gps.dispose();
    super.dispose();
  }
}
