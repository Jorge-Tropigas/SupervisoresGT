// Package imports:
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:app_supervisores_gt/core/service/env_service.dart';

class AppVersion {
  static const int manualMajor = 2;

  static Future<String> displayVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    final String version = await semanticVersion();
    final String build = info.buildNumber;

    final versionFull = EnvService.isDevelopment
        ? build.isEmpty
              ? 'v$version'
              : 'v$version+$build'
        : 'v$version';
    return versionFull;
  }

  static Future<String> semanticVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    final List<String> parts = info.version.split('.');

    final String major = manualMajor.toString();
    final String minor = (parts.length > 1) ? parts[1] : '0';
    final String patch = (parts.length > 2) ? parts[2] : '0';

    return '$major.$minor.$patch';
  }

  static String minRequiredVersion() => '2.0.0';
}
