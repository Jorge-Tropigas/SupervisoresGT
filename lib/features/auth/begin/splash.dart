// Dart imports:
import 'dart:developer' as dev;
import 'dart:io';

// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tomza_kit/core/location/gps_service.dart';
import 'package:tomza_kit/ui/components/tomza_dialog.dart';
import 'package:tomza_kit/ui/themes/colors.dart';

// Project imports:
import 'package:app_supervisores_gt/core/routes/route_paths.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
    _prepareApp();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _prepareApp() async {
    final AppLocationService gpsService = AppLocationService();

    try {
      await gpsService.requestPermissionOnInit();
      if (Platform.isAndroid || Platform.isIOS) {
        if (await Permission.locationWhenInUse.isDenied) {
          await Permission.locationWhenInUse.request();
        }
      }
    } catch (e) {
      dev.log('Error al solicitar permisos de ubicación: $e');
    }

    await _handlePermanentlyDeniedPermissionsIfAny();

    await Future.delayed(const Duration(milliseconds: 2500));

    if (mounted) {
      Navigator.pushReplacementNamed(context, RoutePaths.checkImei);
    }
  }

  Future<void> _handlePermanentlyDeniedPermissionsIfAny() async {
    try {
      final PermissionStatus status = await Permission.locationWhenInUse.status;
      if (status.isPermanentlyDenied) {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext ctx) => CustomDialog(
            title: 'Permisos necesarios',
            description: 'Por favor, habilite el permiso de ubicación en la configuración para continuar.',
            type: CustomDialogType.error,
            onAccept: () async {
              Navigator.of(ctx).pop();
              await openAppSettings();
            },
            actions: [
              DialogAction(
                label: 'Configuración',
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await openAppSettings();
                },
                isPrimary: true,
              ),
            ],
          ),
        );
      }
    } catch (e) {
      dev.log('Error comprobando permisos permanentes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TropigasGTColors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: .min,
              children: [
                Image.asset(
                  'assets/images/gt_tropigas_logo_SinFondo.png',
                  width: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),
                Text(
                  'Supervisores GT',
                  style: GoogleFonts.gabarito(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: TropigasGTColors.primary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 64),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      TropigasGTColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
