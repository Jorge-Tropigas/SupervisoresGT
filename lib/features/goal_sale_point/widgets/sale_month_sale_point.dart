// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tomza_kit/ui/themes/colors.dart';
import 'package:tomza_kit/utils/responsive.dart';

// Project imports:
import 'package:app_supervisores_gt/features/dashboard/models/metric_point.dart';
import 'package:app_supervisores_gt/utils/utils/card_app.dart';

class SaleMonthSalePoint extends StatelessWidget {
  const SaleMonthSalePoint({
    super.key,
    required this.isSmallMobile,
    required this.monthlyCylinderSales,
    this.title = 'Ventas Por Mes',
  });

  final bool isSmallMobile;
  final List<MetricPoint> monthlyCylinderSales;
  final String title;

  static const List<Color> _cylinderColors = <Color>[
    Color(0xFF2196F3),
    Color(0xFF4CAF50),
    Color(0xFFFF9800),
    Color(0xFFE91E63),
    Color(0xFF9C27B0),
    Color(0xFF00BCD4),
    Color(0xFFFF5722),
    Color(0xFF607D8B),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;

    final List<Color> colors = List<Color>.generate(
      monthlyCylinderSales.length,
      (int i) => _cylinderColors[i % _cylinderColors.length],
    );

    return CardApp(
      borderRadius: isMobile ? 12 : 16,
      margin: EdgeInsets.all(isMobile ? 12 : 16),
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.show_chart,
                color: TropigasGTColors.circleBackground,
                size: isMobile ? 18 : 22,
              ),
              SizedBox(width: isMobile ? 8 : 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 12 : 16),
          if (monthlyCylinderSales.isEmpty)
            Container(
              height: isMobile ? 200 : 250,
              alignment: Alignment.center,
              child: Text(
                'SIN VENTAS',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            )
          else ...<Widget>[
            SizedBox(
              height: isMobile ? 220 : 240,
              child: RepaintBoundary(
                child: SfCircularChart(
                  backgroundColor: Colors.transparent,
                  tooltipBehavior: TooltipBehavior(enable: true, elevation: 2),
                  annotations: <CircularChartAnnotation>[
                    CircularChartAnnotation(
                      widget: Text(
                        'VENTAS',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: isMobile ? 16 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  series: <DoughnutSeries<MetricPoint, String>>[
                    DoughnutSeries<MetricPoint, String>(
                      dataSource: monthlyCylinderSales,
                      xValueMapper: (MetricPoint p, _) => p.metric,
                      yValueMapper: (MetricPoint p, _) => p.value,
                      pointColorMapper: (MetricPoint p, int i) =>
                          colors[i % colors.length],
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isMobile ? 16 : 20),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List<Widget>.generate(
                monthlyCylinderSales.length,
                (int j) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: isMobile ? 12 : 14,
                      height: isMobile ? 12 : 14,
                      color: colors[j],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      monthlyCylinderSales[j].metric,
                      style: TextStyle(fontSize: isMobile ? 12 : 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
