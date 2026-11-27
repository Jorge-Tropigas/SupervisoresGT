// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:tomza_kit/ui/components/tomza_dialog.dart';
import 'package:tomza_kit/ui/themes/colors.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/features/auth/check_imei/logic/check_imei_logic.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';

class CheckImeiPage extends StatelessWidget {
  const CheckImeiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckImeiLogic>(
      create: (context) => CheckImeiLogic(repository: sl.get<Repository>()),
      child: Consumer<CheckImeiLogic>(
        builder: (context, model, child) {
          // Configurar callbacks una sola vez. Las acciones de Navigator/diálogo
          // se difieren al siguiente frame porque el bloc puede dispararlas de
          // forma síncrona (p. ej. desde setCallbacks) mientras este builder
          // todavía se está ejecutando, y tocar el Navigator en ese momento
          // provoca errores de "setState() called during build".
          model.setCallbacks(
            onNavigate: (route) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, route);
                }
              });
            },
            onShowDialog: (title, description, type) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  showDialog<void>(
                    context: context,
                    builder: (context) => CustomDialog(
                      title: title,
                      description: description,
                      type: CustomDialogType.info,
                      onAccept: () => Navigator.pop(context),
                    ),
                  );
                }
              });
            },
            onShowDialogWithAction: (title, description, type, {onAccept}) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  showDialog<void>(
                    context: context,
                    builder: (context) => CustomDialog(
                      title: title,
                      description: description,
                      type: CustomDialogType.info,
                      onAccept: () {
                        Navigator.pop(context);
                        onAccept?.call();
                      },
                    ),
                  );
                }
              });
            },
          );

          return Scaffold(
            backgroundColor: TropigasGTColors.scaffoldBackground,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Animación Lottie de validación de IMEI
                  Lottie.asset(
                    'assets/animations/imei_validator.json',
                    width: 260,
                    height: 260,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Verificando Imei...',
                    style: GoogleFonts.gabarito(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Indicador de carga rotativo estático / CSS-like
                  const _StaticRotatingArc(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Indicador reutilizable de arco giratorio (versión sin animación dependiente del model)
class _StaticRotatingArc extends StatefulWidget {
  const _StaticRotatingArc();

  @override
  State<_StaticRotatingArc> createState() => _StaticRotatingArcState();
}

class _StaticRotatingArcState extends State<_StaticRotatingArc>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 3,
          ),
        ),
        child: CustomPaint(painter: _LoadingPainter()),
      ),
    );
  }
}

// Painter personalizado para el indicador de carga
class _LoadingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2 - 3;

    // Dibujar arco de carga
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      3.14159, // Medio círculo
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
