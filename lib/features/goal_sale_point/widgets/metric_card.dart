// Package imports:
import 'package:material_ui/material_ui.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.spark,
    required this.color,
    required this.label,
    required this.valueStyle,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final List<double> spark;
  final Color color;
  final TextStyle label;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    final bool hasSpark = spark.length >= 2;
    double maxV = 0;
    if (hasSpark) {
      maxV = spark.reduce((double a, double b) => a > b ? a : b);
      if (maxV <= 0) {
        maxV = 1;
      }
    }
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('$emoji  $title', style: label.copyWith(color: color)),
              const SizedBox(height: 6),
              Text(subtitle, style: valueStyle.copyWith(color: color)),
              const SizedBox(height: 6),
              if (hasSpark)
                SizedBox(
                  height: 28,
                  child: CustomPaint(
                    painter: _SparklinePainter(spark, color, maxV),
                    size: const Size(double.infinity, 28),
                  ),
                )
              else
                Opacity(
                  opacity: 0.4,
                  child: Container(
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color.withValues(alpha: 0.3)),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'sin datos',
                      style: label.copyWith(
                        color: color.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter(this.values, this.color, this.maxV);
  final List<double> values;
  final Color color;
  final double maxV;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) {
      return;
    }
    final Paint line = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final Path path = Path();
    final double stepX = size.width / (values.length - 1);
    for (int i = 0; i < values.length; i++) {
      final double normY = 1 - (values[i] / maxV);
      final double x = i * stepX;
      final double y = normY * (size.height - 4) + 2;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    // Fill under
    final Path fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        colors: <Color>[
          color.withValues(alpha: 0.25),
          color.withValues(alpha: 0.05),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fill, fillPaint);
    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}
