// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tomza_kit/utils/responsive.dart';

// Project imports:
import 'package:app_supervisores_gt/features/dashboard/models/metric_point.dart';
import 'package:app_supervisores_gt/features/dashboard/models/store_chart_config.dart';
import 'package:app_supervisores_gt/utils/utils/card_app.dart';
import 'package:app_supervisores_gt/utils/utils/empty_state_placeholder.dart';

class SalesByMonthCard extends StatelessWidget {
  const SalesByMonthCard({
    super.key,
    required this.configs,
    this.title = 'Ventas Del Mes',
    this.onRetry,
  });

  final List<StoreChartConfig> configs;
  final String title;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;

    return CardApp(
      borderRadius: isMobile ? 12 : 16,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.show_chart, color: Theme.of(context).primaryColor),
              SizedBox(width: isMobile ? 8 : 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 12 : 16),
          if (configs.isEmpty)
            EmptyStatePlaceholder(
              height: isMobile ? 260 : 320,
              message: 'Sin ventas',
              onRetry: onRetry ?? () {},
              animationAsset: 'assets/animations/FirstProject.json',
            )
          else
            for (final StoreChartConfig cfg in configs) ...<Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: isMobile ? 220 : 240,
                    child: RepaintBoundary(
                      child: SfCircularChart(
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CircularSeries<MetricPoint, String>>[
                          DoughnutSeries<MetricPoint, String>(
                            dataSource: cfg.points,
                            xValueMapper: (MetricPoint p, _) => p.metric,
                            yValueMapper: (MetricPoint p, _) => p.value,
                            pointColorMapper: (MetricPoint p, int i) =>
                                cfg.colors[i % cfg.colors.length],
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
                      cfg.points.length,
                      (int j) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: isMobile ? 12 : 14,
                            height: isMobile ? 12 : 14,
                            color: cfg.colors[j % cfg.colors.length],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatLegendLabel(cfg.points[j].metric),
                            style: TextStyle(fontSize: isMobile ? 12 : 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
        ],
      ),
    );
  }

  String _formatLegendLabel(String metric) {
    return metric
        .toUpperCase()
        .replaceAll('CILINDRO DE', 'CIL.')
        .replaceAll('CILINDRO', 'CIL.')
        .replaceAll(' LBS', ' LB');
  }
}
