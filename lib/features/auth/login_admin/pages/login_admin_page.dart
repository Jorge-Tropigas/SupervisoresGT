// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:tomza_kit/ui/components/image/tomza_image.dart';
import 'package:tomza_kit/ui/components/tomza_gradient_button.dart';
import 'package:tomza_kit/ui/login_form/login_form.dart';
import 'package:tomza_kit/ui/themes/colors.dart';
import 'package:tomza_kit/utils/responsive.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/features/auth/login_admin/logic/login_admin_logic.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';

class LoginAdminPage extends StatelessWidget {
  const LoginAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isSmallMobile = context.isSmallMobile;
    const double commonSpacing = 24.0;

    return ChangeNotifierProvider<LoginAdminLogic>(
      create: (context) => LoginAdminLogic(repository: sl.get<Repository>()),
      child: Consumer<LoginAdminLogic>(
        builder: (context, model, child) => Scaffold(
          body: Center(
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
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: .min,
                        crossAxisAlignment: .stretch,
                        children: [
                          Semantics(
                            label: 'Logo de Tropigas',
                            child: const Center(
                              child: TomzaImage.asset(
                                'assets/images/gt_tropigas_logo_SinFondo.png',
                                fit: BoxFit.contain,
                                height: 100,
                              ),
                            ),
                          ),
                          const SizedBox(height: commonSpacing),
                          Text(
                            'Administrador',
                            style: GoogleFonts.gabarito(
                              fontSize: isSmallMobile ? 24 : 28,
                              fontWeight: FontWeight.bold,
                              color: TropigasGTColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: commonSpacing),
                          Text(
                            'Ingrese sus credenciales para continuar',
                            style: GoogleFonts.gabarito(
                              fontSize: 15,
                              color: TropigasGTColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: commonSpacing),
                          LoginForm(
                            shakeTick: model.shakeTick,
                            header: '',
                            userController: model.userController,
                            passwordController: model.passwordController,
                            isLoginLoading: model.isLoginLoading,
                            isPasswordVisible: model.isPasswordVisible,
                            spacing: commonSpacing,
                            // onChanged: () => model.loginAdmin(context),
                          ),
                          const SizedBox(height: commonSpacing),
                          // Login Button
                          TomzaGradientButton(
                            color: TropigasGTColors.circleBackground,
                            isLoading: model.isLoginLoading,
                            onPressed: () => model.loginAdmin(context),
                            child: Text(
                              'INICIAR SESIÓN',
                              style: GoogleFonts.gabarito(
                                color: TropigasGTColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
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
                          SizedBox(height: 25),
                          Text(
                            'Version ${model.version}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.gabarito(
                              fontSize: 16,
                              color: TropigasGTColors.circleBackgroundDis,
                              fontStyle: .italic,
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
