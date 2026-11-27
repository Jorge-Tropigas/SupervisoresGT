// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/ui/themes/colors.dart';

// Project imports:
import 'package:app_supervisores_gt/features/dashboard/models/metric_point.dart';
import 'package:app_supervisores_gt/features/dashboard/widgets/animated_sales_gauge.dart';
import 'package:app_supervisores_gt/features/goal_sale_point/widgets/card_grid.dart';

class SalesByDaySalePoint extends StatelessWidget {
  const SalesByDaySalePoint({
    super.key,
    required this.isSmallMobile,
    required this.pointSale,
    required this.stripes,
    required this.totalGoals,
    required this.projected,
    required this.progressPercent,
    required this.monthlyPoints,
  });

  final bool isSmallMobile;
  final String pointSale;
  final double stripes;
  final double totalGoals;
  final double projected;
  final double progressPercent; // 0..100
  final List<MetricPoint> monthlyPoints;

  @override
  Widget build(BuildContext context) {
    final Color metaColor = TropigasGTColors.primary;
    final Color projectedColor = TropigasGTColors.circleBackground;
    final Color actualColor = TropigasGTColors.secondary;

    final double ratio = totalGoals <= 0
        ? 0
        : (stripes / totalGoals).clamp(0, 5);
    final double projectedRatio = totalGoals <= 0
        ? 0
        : (projected / totalGoals).clamp(0, 1);

    return Card(
      margin: EdgeInsets.all(isSmallMobile ? 12 : 16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              isSmallMobile ? 16 : 20,
              isSmallMobile ? 16 : 20,
              isSmallMobile ? 16 : 20,
              isSmallMobile ? 8 : 12,
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.flag_circle_outlined,
                  size: isSmallMobile ? 18 : 22,
                  color: TropigasGTColors.circleBackground,
                ),
                SizedBox(width: isSmallMobile ? 4 : 8),
                Expanded(
                  child: Text(
                    'Resumen - $pointSale',
                    style: TextStyle(
                      fontWeight: .bold,
                      fontSize: isSmallMobile ? 16 : 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmallMobile ? 12 : 20),
            child: Builder(
              builder: (BuildContext context) {
                final Widget gauge = SizedBox(
                  width: isSmallMobile ? double.infinity : 180,
                  height: 180,
                  child: AnimatedSalesGauge(
                    progress: ratio,
                    projectedProgress: projectedRatio,
                    size: 180,
                    strokeWidth: 14,
                    gradientColors: <Color>[
                      projectedColor.withValues(alpha: 0.8),
                      projectedColor,
                    ],
                    backgroundColor: metaColor.withValues(alpha: 0.15),
                    borderColor: metaColor.withValues(alpha: 0.3),
                    needleColor: actualColor,
                  ),
                );

                final Widget cards = CardsGrid(
                  stripes: stripes,
                  totalGoals: totalGoals,
                  projected: projected,
                  progressPercent: progressPercent,
                  monthlyPoints: monthlyPoints,
                  baseColor: actualColor,
                  isMobile: isSmallMobile,
                );

                if (isSmallMobile) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(child: gauge),
                      const SizedBox(height: 16),
                      cards,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    gauge,
                    const SizedBox(width: 24),
                    Expanded(child: cards),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: isSmallMobile ? 16 : 20),
        ],
      ),
    );
  }
}

typedef SalesDayGoals = SalesByDaySalePoint;
