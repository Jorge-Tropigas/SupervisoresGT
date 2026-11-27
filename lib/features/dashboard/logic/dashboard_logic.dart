// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomza_kit/core/network/connectivity_handler.dart';
import 'package:tomza_kit/ui/components/tomza_dialog.dart';
import 'package:tomza_kit/ui/themes/colors.dart';
import 'package:tomza_kit/utils/network_check.dart';
import 'package:tomza_kit/utils/notifier.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/model/request/get_cylinder_sales_user_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/retrieve_goals_user_request.dart';
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/global/global_bloc.dart';
import 'package:app_supervisores_gt/features/dashboard/model/cylinder_sales.dart';
import 'package:app_supervisores_gt/features/dashboard/models/metric_point.dart';
import 'package:app_supervisores_gt/features/dashboard/models/store_chart_config.dart';

class DashboardLogic extends ChangeNotifier {
  DashboardLogic({
    required this.context,
    required this._repository,
    required this.global,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialogGesture();
      refresh();
    });
  }

  final Repository _repository;
  final BuildContext context;
  final GlobalBloc global;

  double progressPercent = 0.0;
  double stripes = 0.0;
  double totalGoals = 0.0;
  double gallons = 0.0;
  double projected = 0.0;
  List<CylinderSales> cylinders = <CylinderSales>[];
  List<StoreChartConfig> chartConfigs = <StoreChartConfig>[];

  bool _isDisposed = false;
  bool initialized = false;
  bool warningChecked = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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

  Future<void> refresh() async {
    if (_isDisposed) return;
    initialized = false;
    warningChecked = false;
    setLoading(true);

    await loadGoalsByUser();
    await loadCylinderSalesByUser();

    setLoading(false);
    initialized = true;
    notifyListeners();
  }

  Future<void> loadGoalsByUser() async {
    if (!await NetworkUtils.hasInternet()) {
      showError('Conectate a internet, o tienes muy poca señal a internet!');
      return;
    }

    if (!await ConnectivityHandler.hasExcellentSignal()) {
      showError(
        'Señal débil o inestable. Para ingresar debe tener una señal excelente',
      );
      return;
    }

    try {
      final request = RetrieveGoalsByUserRequest(user: global.currentUser.user);
      final result = await _repository.retrieveGoalsByUser(request);

      _updateGoalsData(
        totalGoals: result.goal,
        stripes: result.gallons,
        projected: result.projected,
      );
    } catch (e) {
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> loadCylinderSalesByUser() async {
    if (!await NetworkUtils.hasInternet()) {
      showError('Conectate a internet, o tienes muy poca señal a internet!');
      return;
    }

    if (!await ConnectivityHandler.hasExcellentSignal()) {
      showError(
        'Señal débil o inestable. Para ingresar debe tener una señal excelente',
      );
      return;
    }

    try {
      final request = GetCylinderSalesUserRequest(
        user: global.currentUser.user,
      );
      final result = await _repository.getCylinderSalesUser(request);

      cylinders = result.cylinders;
      chartConfigs = _buildChartConfigs();
      notifyListeners();
    } catch (e) {
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _updateGoalsData({
    double? totalGoals,
    double? stripes,
    double? projected,
  }) {
    if (_isDisposed) return;
    this.totalGoals = totalGoals ?? 0.0;
    gallons = stripes ?? 0.0;
    this.projected = projected ?? 0.0;

    if (this.totalGoals > 0) {
      progressPercent = (gallons / this.totalGoals).clamp(0.0, 1.0);
    } else {
      progressPercent = 0.0;
    }

    notifyListeners();
  }

  void showWarningIfNoGoals() {
    if (warningChecked) return;
    warningChecked = true;
    if (totalGoals <= 0 && initialized) {
      showError('No se encontró meta para el usuario');
    }
  }

  double calculateProgress(double current, double target) {
    if (target <= 0) return 0.0;
    return (current / target).clamp(0.0, 5.0);
  }

  void clearData() {
    if (_isDisposed) return;
    progressPercent = 0.0;
    projected = 0.0;
    totalGoals = 0.0;
    gallons = 0.0;
    cylinders = <CylinderSales>[];
    chartConfigs = <StoreChartConfig>[];
    notifyListeners();
  }

  Map<String, dynamic> getProgressColors(double progress) {
    final Color success = const Color(0xFF4CAF50);
    final Color warning = TropigasGTColors.circleBackground;
    final Color danger = const Color(0xFFE53935);

    late Color main;
    final Color background = TropigasGTColors.primary.withValues(alpha: 0.1);

    if (progress >= 0.85) {
      main = success;
    } else if (progress >= 0.65) {
      main = warning;
    } else {
      main = danger;
    }

    final Color light = Color.lerp(main, Colors.white, 0.4)!;
    final Color dark = Color.lerp(main, TropigasGTColors.primary, 0.2)!;

    return <String, dynamic>{
      'main': main,
      'border': main.withValues(alpha: 0.3),
      'background': background,
      'gradient': <Color>[light, main, dark],
    };
  }

  List<StoreChartConfig> _buildChartConfigs() {
    if (cylinders.isEmpty) return <StoreChartConfig>[];

    final Map<String, double> aggregated = <String, double>{};
    for (final CylinderSales c in cylinders) {
      aggregated[c.description] =
          (aggregated[c.description] ?? 0) + c.quantity.toDouble();
    }

    final List<MetricPoint> points = aggregated.entries
        .map((MapEntry<String, double> e) => MetricPoint(e.key, e.value))
        .toList();

    if (points.isEmpty) return <StoreChartConfig>[];

    final List<Color> colors = List<Color>.generate(
      points.length,
      (int i) => _cylinderColors[i % _cylinderColors.length],
    );

    return <StoreChartConfig>[
      StoreChartConfig(storeName: 'Cilindros', points: points, colors: colors),
    ];
  }

  Future<void> showDialogGesture() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final String today = '${now.year}-${now.month}-${now.day}';
    final String? lastShownDate = prefs.getString('last_gesture_dialog_date');

    if (lastShownDate != today) {
      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (context) => CustomDialog(
          title: 'Gestos',
          description: 'Para ocultar el mensaje de exito o error puede deslizar el mensaje para abajo!',
          type: CustomDialogType.warning,
          onAccept: () async {
            await prefs.setString('last_gesture_dialog_date', today);
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  void setLoading(bool value) {
    if (_isDisposed) return;
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
