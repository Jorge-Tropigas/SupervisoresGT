// Package imports:
import 'package:material_ui/material_ui.dart';

// Project imports:
import 'package:app_supervisores_gt/features/dashboard/models/metric_point.dart';
import 'package:app_supervisores_gt/features/goal_sale_point/widgets/metric_card.dart';

class CardsGrid extends StatelessWidget {
  const CardsGrid({
    super.key,
    required this.stripes,
    required this.totalGoals,
    required this.projected,
    required this.progressPercent,
    required this.monthlyPoints,
    required this.baseColor,
    required this.isMobile,
  });

  final double stripes;
  final double totalGoals;
  final double projected;
  final double progressPercent;
  final List<MetricPoint> monthlyPoints;
  final Color baseColor;
  final bool isMobile;

  List<double> _sparkValues() {
    if (monthlyPoints.isEmpty) {
      return <double>[];
    }
    return monthlyPoints.map((MetricPoint e) => e.value).toList();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle label = Theme.of(context).textTheme.labelSmall!
        .copyWith(fontWeight: FontWeight.w600, letterSpacing: .5);
    final TextStyle valueStyle = Theme.of(context).textTheme.titleMedium!
        .copyWith(fontWeight: FontWeight.bold);
    final List<double> spark = _sparkValues();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color metaColor = isDark ? Colors.orangeAccent : Colors.orange;
    final Color projectedColor = isDark ? Colors.greenAccent : Colors.green;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MetricCard(
            emoji: '🎯',
            title: 'Meta',
            subtitle: totalGoals.toStringAsFixed(2),
            spark: spark,
            color: metaColor,
            label: label,
            valueStyle: valueStyle,
          ),
          const SizedBox(height: 12),
          MetricCard(
            emoji: '💧',
            title: 'Vendido',
            subtitle:
                '${stripes.toStringAsFixed(2)}  (${progressPercent.toStringAsFixed(1)}%)',
            spark: spark,
            color: baseColor,
            label: label,
            valueStyle: valueStyle,
          ),
          const SizedBox(height: 12),
          MetricCard(
            emoji: '📈',
            title: 'Proyectado',
            subtitle: projected.toStringAsFixed(2),
            spark: spark,
            color: projectedColor,
            label: label,
            valueStyle: valueStyle,
          ),
        ],
      );
    }

    // En pantallas grandes un grid de 3 columnas.
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      children: <Widget>[
        MetricCard(
          emoji: '🎯',
          title: 'Meta',
          subtitle: totalGoals.toStringAsFixed(2),
          spark: spark,
          color: metaColor,
          label: label,
          valueStyle: valueStyle,
        ),
        MetricCard(
          emoji: '💧',
          title: 'Vendido',
          subtitle:
              '${stripes.toStringAsFixed(2)}  (${progressPercent.toStringAsFixed(1)}%)',
          spark: spark,
          color: baseColor,
          label: label,
          valueStyle: valueStyle,
        ),
        MetricCard(
          emoji: '📈',
          title: 'Proyectado',
          subtitle: projected.toStringAsFixed(2),
          spark: spark,
          color: projectedColor,
          label: label,
          valueStyle: valueStyle,
        ),
      ],
    );
  }
}
