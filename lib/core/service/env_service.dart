// Flutter imports:
import 'package:flutter/foundation.dart' show kReleaseMode;

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvService {
  static String? _activeEnv;

  static Future<void> init({String fileName = '.env', String? env}) async {
    try {
      await dotenv.load(fileName: fileName);
      if (env != null) {
        _activeEnv = env;
      }
    } catch (e) {
      throw Exception('No se pudo cargar el archivo de entorno: $fileName');
    }
  }

  static String get baseUrl {
    final String current = flavor.toLowerCase();
    final String? dev = _getEnvVariable('API_URL_DEV');
    final String? prod = _getEnvVariable('API_URL_PROD');
    final String? genericA = _getFirstNonEmpty(<String>[
      'API_URL',
      'API_BASE_URL',
      'BASE_URL',
    ]);

    if (current == 'production') {
      return (prod ?? genericA ?? dev ?? '').trim();
    }
    return (dev ?? genericA ?? prod ?? '').trim();
  }

  static String get flavor {
    if (_activeEnv != null) {
      final String lower = _activeEnv!.toLowerCase();
      if (lower == 'prod' || lower == 'production') {
        return 'production';
      }
      if (lower == 'dev' || lower == 'development') {
        return 'development';
      }
    }
    return kReleaseMode ? 'production' : 'development';
  }

  static bool get isDevelopment => flavor.toLowerCase() == 'development';

  static String get appName =>
      _getEnvVariable('APP_NAME') ??
      (isDevelopment ? 'Portatil GT Dev' : 'Portatil GT');

  static bool get debugMode =>
      _getEnvVariable('DEBUG_MODE')?.toLowerCase() == 'true';

  static bool get featureFlag =>
      _getEnvVariable('FEATURE_FLAG')?.toLowerCase() == 'true';

  static bool get insecureSsl =>
      _getEnvVariable('INSECURE_SSL')?.toLowerCase() == 'true';

  static String get apiKeyFirebaseDev =>
      _getEnvVariable('API_KEY_FIREBASE_DEV') ?? '';
  static String get appIdFirebaseDev =>
      _getEnvVariable('APP_ID_FIREBASE_DEV') ?? '';
  static String get messagingSenderIdFirebaseDev =>
      _getEnvVariable('MESSAGING_SENDER_ID_FIREBASE_DEV') ?? '';
  static String get projectIdFirebaseDev =>
      _getEnvVariable('PROJECT_ID_FIREBASE_DEV') ?? '';
  static String get storageBucketFirebaseDev =>
      _getEnvVariable('STORAGE_BUCKET_FIREBASE_DEV') ?? '';

  static String get apiKeyFirebase => _getEnvVariable('API_KEY_FIREBASE') ?? '';
  static String get appIdFirebase => _getEnvVariable('APP_ID_FIREBASE') ?? '';
  static String get messagingSenderIdFirebase =>
      _getEnvVariable('MESSAGING_SENDER_ID_FIREBASE') ?? '';
  static String get projectIdFirebase =>
      _getEnvVariable('PROJECT_ID_FIREBASE') ?? '';
  static String get storageBucketFirebase =>
      _getEnvVariable('STORAGE_BUCKET_FIREBASE') ?? '';

  static String get baseUrlNormalized {
    final String b = baseUrl.trim();
    if (b.isEmpty) {
      return b;
    }
    return b.endsWith('/') ? b : '$b/';
  }

  static String? _getEnvVariable(String key) {
    final String? value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  static String? _getFirstNonEmpty(List<String> keys) {
    for (final String k in keys) {
      final String? v = _getEnvVariable(k);
      if (v != null && v.trim().isNotEmpty) {
        return v.trim();
      }
    }
    return null;
  }
}
