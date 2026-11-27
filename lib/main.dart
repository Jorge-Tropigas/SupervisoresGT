// Dart imports:
import 'dart:developer' as dev;

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:app_supervisores_gt/core/app/app.dart';
import 'package:app_supervisores_gt/core/service/env_service.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const String flavorEnv = String.fromEnvironment('FLUTTER_APP_FLAVOR');

  String activeEnv = 'prod';
  if (appFlavor != null && appFlavor!.isNotEmpty) {
    activeEnv = appFlavor!;
  } else if (flavorEnv.isNotEmpty) {
    activeEnv = flavorEnv;
  } else {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (packageInfo.packageName.endsWith('.dev')) {
        activeEnv = 'dev';
      }
    } catch (e) {
      dev.log('Error al obtener el flavor: $e');
    }
  }

  final String envFileName = activeEnv == 'prod' ? 'env.prod' : 'env.dev';
  await EnvService.init(fileName: envFileName, env: activeEnv);

  await initDependencies();

  runApp(const MyApp());
}
