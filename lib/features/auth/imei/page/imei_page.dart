// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:tomza_kit/ui/components/image/tomza_image.dart';
import 'package:tomza_kit/ui/components/input/tomza_user_input.dart';
import 'package:tomza_kit/ui/components/tomza_gradient_button.dart';
import 'package:tomza_kit/ui/themes/colors.dart';
import 'package:tomza_kit/utils/responsive.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/features/auth/imei/logic/imei_bloc.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';

class ImeiPage extends StatelessWidget {
  const ImeiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isSmallMobile = context.isSmallMobile;

    return ChangeNotifierProvider(
      create: (context) =>
          ImeiLogic(context: context, repository: sl.get<Repository>()),
      child: Scaffold(
        backgroundColor: TropigasGTColors.scaffoldBackground,
        body: Consumer<ImeiLogic>(
          builder: (context, model, child) => SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24.0 : 40.0,
                  vertical: 16.0,
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Form(
                      key: model.imeiFormKey,
                      child: Column(
                        mainAxisAlignment: .center,
                        crossAxisAlignment: .center,
                        children: [
                          Center(
                            child: TomzaImage.asset(
                              'assets/images/gt_tropigas_logo_SinFondo.png',
                              fit: BoxFit.contain,
                              height: 120,
                            ),
                          ),
                          SizedBox(height: 48),
                          // Title
                          Text(
                            'Verificación IMEI',
                            style: GoogleFonts.gabarito(
                              fontSize: isSmallMobile ? 28 : 32,
                              fontWeight: FontWeight.bold,
                              color: TropigasGTColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ingrese el IMEI de su dispositivo para continuar',
                            style: GoogleFonts.gabarito(
                              fontSize: 16,
                              color: TropigasGTColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          // IMEI Input Field
                          UserInput(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            title: 'Número de IMEI',
                            controller: model.imeiController,
                            label: 'IMEI',
                            hint: 'Ingrese los 15 dígitos',
                            prefixIcon: const Icon(
                              Icons.phone_iphone_rounded,
                              color: TropigasGTColors.primary,
                            ),
                            keyboardType:
                                const TextInputType.numberWithOptions(),
                            validator: model.validateIMEIInput,
                            maxLength: 15,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(15),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // Continue Button
                          TomzaGradientButton(
                            color: TropigasGTColors.circleBackground,
                            isLoading: model.isLoading,
                            onPressed: () => model.validateIMEI(),
                            child: Text(
                              'CONTINUAR',
                              style: GoogleFonts.gabarito(
                                color: TropigasGTColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Help Link
                          Center(
                            child: TextButton(
                              onPressed: () => model.showImeiHelpDialog(),
                              style: TextButton.styleFrom(
                                foregroundColor: TropigasGTColors.secondary,
                              ),
                              child: Text(
                                '¿Cómo encontrar mi IMEI?',
                                style: GoogleFonts.gabarito(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Accent underline/divider with Accent Color
                          Center(
                            child: Container(
                              height: 4,
                              width: 60,
                              decoration: BoxDecoration(
                                color: TropigasGTColors.accent,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
