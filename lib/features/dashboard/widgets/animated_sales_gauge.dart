// Dart imports:
import 'dart:math' as math;

// Package imports:
import 'package:material_ui/material_ui.dart';

/// Gauge circular animado estilo velocímetro para mostrar el avance (%)
class AnimatedSalesGauge extends StatefulWidget {
  const AnimatedSalesGauge({
    required this.progress,
    this.projectedProgress = 0,
    this.size = 220,
    this.strokeWidth = 14,
    this.gradientColors = const <Color>[Colors.red, Colors.orange],
    this.backgroundColor = const Color(0x11000000),
    this.borderColor = const Color(0x22000000),
    this.needleColor,
    this.animationDuration = const Duration(milliseconds: 1400),
    this.curve = Curves.easeInOutCubic,
    this.labelStyle,
    this.subtitleStyle,
    super.key,
  });

  /// Valor entre 0 y 1 (Ventas reales - Aguja)
  final double? progress;

  /// Valor entre 0 y 1 (Proyectado - Arco)
  final double? projectedProgress;
  final double size;
  final double strokeWidth;
  final List<Color> gradientColors;
  final Color backgroundColor;
  final Color borderColor;
  final Color? needleColor;
  final Duration animationDuration;
  final Curve curve;
  final TextStyle? labelStyle;
  final TextStyle? subtitleStyle;

  @override
  State<AnimatedSalesGauge> createState() => _AnimatedSalesGaugeState();
}

class _AnimatedSalesGaugeState extends State<AnimatedSalesGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _actualAnimation;
  late Animation<double> _projectedAnimation;
  double _oldActual = 0;
  double _oldProjected = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _initAnimations(
      0,
      widget.progress ?? 0.0,
      0,
      widget.projectedProgress ?? 0.0,
    );
    _controller.forward();
  }

  void _initAnimations(
    double beginActual,
    double endActual,
    double beginProjected,
    double endProjected,
  ) {
    _actualAnimation = Tween<double>(
      begin: beginActual,
      end: endActual,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _projectedAnimation = Tween<double>(
      begin: beginProjected,
      end: endProjected,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  void didUpdateWidget(covariant AnimatedSalesGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress ||
        oldWidget.projectedProgress != widget.projectedProgress) {
      // Intentar obtener valores actuales de forma segura
      double currentActual = 0;
      double currentProjected = 0;

      try {
        currentActual = _actualAnimation.value;
        currentProjected = _projectedAnimation.value;
      } catch (_) {
        currentActual = oldWidget.progress ?? 0.0;
        currentProjected = oldWidget.projectedProgress ?? 0.0;
      }

      _oldActual = currentActual;
      _oldProjected = currentProjected;

      _controller.reset();
      _initAnimations(
        _oldActual,
        widget.progress ?? 0.0,
        _oldProjected,
        widget.projectedProgress ?? 0.0,
      );
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle =
        widget.labelStyle ?? Theme.of(context).textTheme.headlineMedium!;
    final TextStyle subtitleStyle =
        widget.subtitleStyle ?? Theme.of(context).textTheme.labelMedium!;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            painter: _GaugePainter(
              actualProgress: _actualAnimation.value,
              projectedProgress: _projectedAnimation.value,
              strokeWidth: widget.strokeWidth,
              gradientColors: widget.gradientColors,
              backgroundColor: widget.backgroundColor,
              borderColor: widget.borderColor,
              needleColor: widget.needleColor,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '${(_actualAnimation.value * 100).clamp(0, 100).toStringAsFixed(1)}%',
                    style: labelStyle,
                  ),
                  const SizedBox(height: 4),
                  Text('Avance', style: subtitleStyle),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.actualProgress,
    required this.projectedProgress,
    required this.strokeWidth,
    required this.gradientColors,
    required this.backgroundColor,
    required this.borderColor,
    this.needleColor,
  });

  final double actualProgress;
  final double projectedProgress;
  final double strokeWidth;
  final List<Color> gradientColors;
  final Color backgroundColor;
  final Color borderColor;
  final Color? needleColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double startAngle = math.pi * 0.75; // 135°
    final double sweepAngle = math.pi * 1.5; // 270°

    final Offset center = size.center(Offset.zero);
    final double radius = (size.shortestSide - strokeWidth) / 2;

    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    // 1. Fondo (Meta)
    final Paint backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..color = backgroundColor;

    canvas.drawArc(rect, startAngle, sweepAngle, false, backgroundPaint);

    // Borde externo tenue
    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 2
      ..color = borderColor
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect.inflate(1.5),
      startAngle,
      sweepAngle,
      false,
      borderPaint,
    );

    // 2. Progreso Proyectado (Arco)
    if (projectedProgress > 0) {
      final Paint projectedPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle,
          colors: gradientColors,
        ).createShader(rect);

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle * projectedProgress.clamp(0, 1),
        false,
        projectedPaint,
      );
    }

    // 3. Marca de Avance Real (Needle-like / Line)
    final double needleAngle =
        startAngle + sweepAngle * actualProgress.clamp(0, 1);
    final Offset needleStart =
        center + Offset.fromDirection(needleAngle, radius - strokeWidth * 0.8);
    final Offset needleEnd =
        center + Offset.fromDirection(needleAngle, radius + strokeWidth * 0.8);

    final Paint needlePaint = Paint()
      ..color =
          needleColor ??
          (gradientColors.isNotEmpty ? gradientColors.last : Colors.blue)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Dibujar una línea más prominente para el avance real
    canvas.drawLine(needleStart, needleEnd, needlePaint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.actualProgress != actualProgress ||
      oldDelegate.projectedProgress != projectedProgress ||
      oldDelegate.gradientColors != gradientColors ||
      oldDelegate.strokeWidth != strokeWidth;
}
