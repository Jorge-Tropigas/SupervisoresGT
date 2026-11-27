// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:tomza_kit/utils/responsive.dart';

// Project imports:
import 'package:app_supervisores_gt/features/dashboard/logic/dashboard_logic.dart';
import 'package:app_supervisores_gt/features/dashboard/widgets/sales_by_day_card.dart';
import 'package:app_supervisores_gt/features/dashboard/widgets/sales_by_month_card.dart';

class DashboardLayout extends StatelessWidget {
  const DashboardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = context.isMobile;

    return Consumer<DashboardLogic>(
      builder: (context, logic, child) => RefreshIndicator(
        onRefresh: logic.refresh,
        displacement: isMobile ? 32 : 48,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .center,
            children: [
              SizedBox(height: 16),
              SalesByDayCard(
                stripes: logic.stripes,
                totalGoals: logic.totalGoals,
                projected: logic.projected,
                calculateProgress: (double stripes, double totalGoals) =>
                    logic.calculateProgress(stripes, totalGoals),
                getProgressColors: logic.getProgressColors,
              ),
              SizedBox(height: 8),
              SalesByMonthCard(
                configs: logic.chartConfigs,
                onRetry: logic.refresh,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
