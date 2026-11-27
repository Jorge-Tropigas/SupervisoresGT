// Dart imports:
import 'dart:async';

// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomza_kit/core/location/gps_service.dart';
import 'package:tomza_kit/ui/themes/colors.dart';

// Project imports:
import 'package:app_supervisores_gt/core/routes/route_paths.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';

// Project imports:
// import 'package:app_supervisores_gt/core/global/global_bloc.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  bool _navigated = false;
  Timer? _safetyTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPermissionProcess();
    });
  }

  @override
  void dispose() {
    _safetyTimer?.cancel();
    super.dispose();
  }

  Future<void> _navigateToNext() async {
    if (_navigated) return;
    _navigated = true;
    _safetyTimer?.cancel();

    if (mounted) {
      await Navigator.pushReplacementNamed(context, RoutePaths.checkImei);
    }
  }

  Future<void> _startPermissionProcess() async {
    _safetyTimer = Timer(const Duration(seconds: 10), () async {
      debugPrint('Safety timer triggered navigation');
      await _navigateToNext();
    });

    try {
      await _requestPermissionsLogic();
    } catch (e) {
      debugPrint('Error crítico en flujo de permisos: $e');
    } finally {
      await _navigateToNext();
    }
  }

  Future<void> _requestPermissionsLogic() async {
    final AppLocationService gpsService = sl.get<AppLocationService>();
    // 1. Solicitar permisos críticos
    await [Permission.locationWhenInUse, Permission.notification].request();

    // 2. Solicitar permisos de Bluetooth (Android 12+)
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
    ].request();

    // 3. Lógica de ubicación
    final PermissionStatus locationStatus =
        await Permission.locationWhenInUse.status;
    /* final PermissionStatus notificationStatus =
        await Permission.notification.status; */

    if (locationStatus.isGranted) {
      try {
        final bool serviceEnabled = await gpsService.isServiceEnabled();

        if (serviceEnabled) {
          final position = await gpsService.getCurrentPositionDetail(
            timeLimit: const Duration(seconds: 3),
          );

          if (position != null) {
            await _saveLocation(position.latitude, position.longitude);
          } else {
            await _setFallbackLocation();
          }
        } else {
          await _setFallbackLocation();
        }
      } catch (e) {
        await _setFallbackLocation();
      }
    } else {
      await _setFallbackLocation();
    }
    /* final bool isNotificationGranted =
        notificationStatus.isGranted || notificationStatus.isProvisional; */

    /* if (isNotificationGranted) {
      // Sincronizar el permiso en el estado global
      await sl.get<GlobalBloc>().updateNotificationPermission();
      // Se obtiene el token de firebase desde aca y luego se guarda en la base de datos para el envio de notificaciones push
      /* sl.get<NotificationService>().getToken().timeout(
        const Duration(seconds: 4),
      ); */
    } */
  }

  Future<void> _saveLocation(double lat, double lng) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('latitude', lat.toString());
      await prefs.setString('longitude', lng.toString());
    } catch (_) {}
  }

  Future<void> _setFallbackLocation() async {
    final AppLocationService gpsService = sl.get<AppLocationService>();
    try {
      try {
        final lastKnown = await gpsService.getLastKnownPosition();
        if (lastKnown != null) {
          await _saveLocation(lastKnown.latitude, lastKnown.longitude);
          return;
        }
      } catch (_) {}
      await _saveLocation(0.0, 0.0);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: TropigasGTColors.scaffoldBackground,
      body: Center(
        child: CircularProgressIndicator(color: TropigasGTColors.primary),
      ),
    );
  }
}
