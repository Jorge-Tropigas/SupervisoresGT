// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/ui/themes/colors.dart';
import 'package:tomza_kit/utils/animated_snack_content.dart';
import 'package:tomza_kit/utils/error.dart' as kit_error;

// Project imports:
import 'package:app_supervisores_gt/core/routes/route_paths.dart';
import 'package:app_supervisores_gt/core/routes/route_switch.dart';
import 'package:app_supervisores_gt/core/service/env_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static GlobalKey<ScaffoldMessengerState>? foregroundScaffoldMessengerKey;

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'es_GT';
    kit_error.ErrorNotifier.initialize(
      messengerKey: MyApp.scaffoldMessengerKey,
      callback: (message, icon, color) {
        void showSnack() {
          final ScaffoldMessengerState? messenger =
              MyApp.foregroundScaffoldMessengerKey?.currentState ??
              MyApp.scaffoldMessengerKey.currentState;
          if (messenger == null) return;
          final SnackBar snack = SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: color.withValues(alpha: 0.94),
            elevation: 5,
            content: AnimatedSnackContent(
              icon: icon,
              color: Colors.white,
              text: message,
            ),
            duration: const Duration(seconds: 7),
          );
          messenger
            ..clearSnackBars()
            ..showSnackBar(snack);
        }

        final foregroundKey = MyApp.foregroundScaffoldMessengerKey;
        final shouldWaitForMessenger =
            (foregroundKey != null && foregroundKey.currentState == null) ||
            (foregroundKey == null &&
                MyApp.scaffoldMessengerKey.currentState == null);

        if (shouldWaitForMessenger) {
          WidgetsBinding.instance.addPostFrameCallback((_) => showSnack());
        } else {
          showSnack();
        }
      },
    );

    return MaterialApp(
      scaffoldMessengerKey: MyApp.scaffoldMessengerKey,
      title: EnvService.appName,
      theme: ThemeData(
        useMaterial3: true,
        useSystemColors: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: TropigasGTColors.primary,
          primary: TropigasGTColors.primary,
          secondary: TropigasGTColors.secondary,
          surface: TropigasGTColors.scaffoldBackground,
          onSurface: TropigasGTColors.textPrimary,
          error: const Color(0xFFD32F2F),
        ),
        scaffoldBackgroundColor: TropigasGTColors.scaffoldBackground,
        appBarTheme: AppBarTheme(
          backgroundColor: TropigasGTColors.scaffoldBackground,
          foregroundColor: TropigasGTColors.textPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.gabarito(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: TropigasGTColors.textPrimary,
          ),
          iconTheme: const IconThemeData(color: TropigasGTColors.textPrimary),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: TropigasGTColors.scaffoldBackground),
          ),
          color: TropigasGTColors.scaffoldBackground,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: TropigasGTColors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: TropigasGTColors.scaffoldBackground,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: TropigasGTColors.scaffoldBackground,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: TropigasGTColors.primary,
              width: 1.5,
            ),
          ),
          labelStyle: GoogleFonts.gabarito(
            color: TropigasGTColors.textSecondary,
          ),
          hintStyle: GoogleFonts.gabarito(
            color: TropigasGTColors.textSecondary.withValues(alpha: 0.6),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.gabarito(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      onGenerateRoute: RouteSwitch.onGenerateRoute,
      initialRoute: RoutePaths.splash,
      debugShowCheckedModeBanner: kDebugMode ? true : false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('es')],
    );
  }
}
