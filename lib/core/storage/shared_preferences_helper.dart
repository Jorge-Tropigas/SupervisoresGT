// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:app_supervisores_gt/features/auth/login_user/model/user.dart';

class SharedPreferencesHelper {
  final SharedPreferences _prefs;

  SharedPreferencesHelper(this._prefs);

  final String isLoggedIn = 'is_logged_in';

  /// Retorna si el usuario está marcado como logueado en preferencias
  bool get isUserLoggedIn => _prefs.getBool(isLoggedIn) ?? false;
  static const String _keyUser = 'current_user';
  static const String _keyImeiValidated = 'imei_validated_once';
  static const String _keyManualImei = 'manual_entered_imei';
  static const String _keyFallbackDeviceId = 'fallback_device_id';
  static const String _keyLastValidatedImei = 'last_validated_imei_v1';
  static const String _keyUserJson = 'user_json_v1';
  static const String _keyLastUser = 'last_logged_in_user';

  Future<void> setImeiValidatedOnce(bool done) async {
    try {
      await _prefs.setBool(_keyImeiValidated, done);
    } catch (e) {
      throw Exception('Error al guardar imeiValidated: ${e.toString()}');
    }
  }

  Future<bool> isImeiValidatedOnce() async {
    try {
      return _prefs.getBool(_keyImeiValidated) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> saveManualImei(String imei) async {
    try {
      await _prefs.setString(_keyManualImei, imei);
    } catch (e) {
      throw Exception('Error al guardar IMEI manual: ${e.toString()}');
    }
  }

  Future<String?> getManualImei() async {
    try {
      return _prefs.getString(_keyManualImei);
    } catch (e) {
      return null;
    }
  }

  Future<String> getOrCreateFallbackDeviceId() async {
    final String? existing = _prefs.getString(_keyFallbackDeviceId);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final String generated = const Uuid().v4();
    await _prefs.setString(_keyFallbackDeviceId, generated);
    return generated;
  }

  Future<void> saveLastValidatedImei(String imei) async {
    try {
      await _prefs.setString(_keyLastValidatedImei, imei);
    } catch (e) {
      throw Exception('Error al guardar último IMEI validado: ${e.toString()}');
    }
  }

  Future<String?> getLastValidatedImei() async {
    try {
      return _prefs.getString(_keyLastValidatedImei);
    } catch (e) {
      return null;
    }
  }

  /// Guarda la información del usuario logueado
  ///
  /// [user] Información del usuario a guardar
  Future<void> saveUser(User user) async {
    try {
      final String userJson = jsonEncode(user.toJson());
      await _prefs.setString(_keyUser, userJson);
      await _prefs.setBool(isLoggedIn, true);
      // Guardamos también bajo clave extendida para futuras migraciones.
      await _prefs.setString(_keyUserJson, userJson);
      await _prefs.setString(_keyLastUser, user.user);
    } catch (e) {
      throw Exception('Error al guardar usuario: ${e.toString()}');
    }
  }

  Future<String?> getLastUser() async {
    try {
      return _prefs.getString(_keyLastUser);
    } catch (_) {
      return null;
    }
  }

  /// Guarda el idUsuario del último usuario logueado
  Future<void> saveLastUser(String user) async {
    try {
      await _prefs.setString(_keyLastUser, user);
    } catch (e) {
      throw Exception('Error al guardar último usuario: ${e.toString()}');
    }
  }
}
