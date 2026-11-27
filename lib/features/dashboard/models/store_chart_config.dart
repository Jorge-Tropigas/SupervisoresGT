// Configuración para gráfico por tienda

// Package imports:
import 'package:material_ui/material_ui.dart';

// Project imports:
import 'package:app_supervisores_gt/features/dashboard/models/metric_point.dart';

class StoreChartConfig {
  StoreChartConfig({
    required this.storeName,
    required this.points,
    required this.colors,
  });

  final String storeName;
  final List<MetricPoint> points;
  final List<Color> colors;
}
