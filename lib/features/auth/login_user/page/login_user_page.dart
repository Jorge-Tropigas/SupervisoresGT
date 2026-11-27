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
import 'package:app_supervisores_gt/core/global/global_bloc.dart';
import 'package:app_supervisores_gt/features/auth/login_user/logic/login_user_logic.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';

class LoginUserPage extends StatelessWidget {
  const LoginUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isSmallMobile = context.isSmallMobile;
    const double commonSpacing = 24.0;

    return ChangeNotifierProvider<LoginUserLogic>(
      create: (context) => LoginUserLogic(
        context: context,
        repository: sl.get<Repository>(),
        global: sl.get<GlobalBloc>(),
      ),
      child: Scaffold(
        backgroundColor: TropigasGTColors.scaffoldBackground,
        body: Consumer<LoginUserLogic>(
          builder: (context, model, child) => SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24.0 : 40.0,
                  vertical: 16.0,
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: .center,
                        crossAxisAlignment: .center,
                        mainAxisSize: .min,
                        children: [
                          const SizedBox(height: commonSpacing),
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
                            'Supervisores',
                            style: GoogleFonts.gabarito(
                              fontSize: isSmallMobile ? 24 : 28,
                              fontWeight: FontWeight.bold,
                              color: TropigasGTColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: commonSpacing),
                          Text(
                            'Inicie sesión para capturar datos',
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
                            // onChanged: () => model.login(),
                          ),
                          const SizedBox(height: commonSpacing),
                          TomzaGradientButton(
                            color: TropigasGTColors.circleBackground,
                            isLoading: model.isLoginLoading,
                            onPressed: () => model.login(),
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
                          const SizedBox(height: commonSpacing * 1),
                          Text(
                            'v ${model.version}',
                            style: GoogleFonts.gabarito(
                              fontSize: 12,
                              color: TropigasGTColors.layoutBorder,
                            ),
                            textAlign: TextAlign.center,
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
