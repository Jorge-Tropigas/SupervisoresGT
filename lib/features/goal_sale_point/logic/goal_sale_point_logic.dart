// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/core/network/connectivity_handler.dart';
import 'package:tomza_kit/utils/network_check.dart';
import 'package:tomza_kit/utils/notifier.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/model/request/get_cylinder_sale_point_sale_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/get_target_sale_point_request.dart';
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/features/dashboard/models/metric_point.dart';
import 'package:app_supervisores_gt/features/goal_sale_point/models/sale_point_cylinder.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/model/arguments_by_visits.dart';

class GoalSalePointLogic extends ChangeNotifier {
  GoalSalePointLogic({
    required this.argumentsByVisits,
    required this._repository,
  }) {
    getGoalsBySalePoint();
    getSalesByCylinder();
  }

  final ArgumentsByVisits argumentsByVisits;
  final Repository _repository;

  double progressPercent = 0.0;
  double projected = 0.0;
  double totalGoals = 0.0;
  double stripes = 0.0;
  List<SalePointCylinder> cylinders = [];
  List<MetricPoint> monthlyCylinderSales = <MetricPoint>[];

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> getGoalsBySalePoint() async {
    setLoading(true);

    if (!await NetworkUtils.hasInternet()) {
      showError('No tienes conexión a internet');
      setLoading(false);
      return;
    }

    if (!await ConnectivityHandler.hasExcellentSignal()) {
      showError(
        'Señal débil o inestable. Para anular una factura debe tener una señal excelente',
      );
      setLoading(false);
      return;
    }

    try {
      final request = GetTargetSalePointRequest(
        salePoint: argumentsByVisits.pointSale,
      );
      final result = await _repository.getTargetSalePoint(request);
      setLoading(false);

      stripes = result.gallons;
      totalGoals = result.goal;
      projected = result.projected;
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> getSalesByCylinder() async {
    setLoading(true);

    if (!await NetworkUtils.hasInternet()) {
      showError('No tienes conexión a internet');
      setLoading(false);
      return;
    }

    if (!await ConnectivityHandler.hasExcellentSignal()) {
      showError(
        'Señal débil o inestable. Para anular una factura debe tener una señal excelente',
      );
      setLoading(false);
      return;
    }

    try {
      final request = GetCylinderSalePointSaleRequest(
        salePoint: argumentsByVisits.pointSale,
      );
      final result = await _repository.getCylinderSalePointSale(request);
      setLoading(false);

      cylinders = result.cylinders;
      monthlyCylinderSales = cylinders
          .map((c) => MetricPoint(c.description, c.quantity.toDouble()))
          .toList();
      showSuccess(result.message ?? 'Ventas obtenidas correctamente');
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  double calculateProgress(double current, double target) {
    if (target <= 0) {
      return 0.0;
    }
    final double progress = (current / target) * 100;
    return progress.clamp(0.0, 100.0);
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
