// Package imports:
import 'package:lottie/lottie.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:tomza_kit/utils/responsive.dart';

// Project imports:
import 'package:app_supervisores_gt/features/goal_sale_point/logic/goal_sale_point_logic.dart';
import 'package:app_supervisores_gt/features/goal_sale_point/widgets/sale_day_sale_point.dart';
import 'package:app_supervisores_gt/features/goal_sale_point/widgets/sale_month_sale_point.dart';

class GoalSalePointLayout extends StatelessWidget {
  const GoalSalePointLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallMobile = context.isSmallMobile;

    return Consumer<GoalSalePointLogic>(
      builder: (context, logic, _) {
        if (logic.isLoading) {
          return Center(
            child: Lottie.asset(
              'assets/animations/loading_fire.json',
              width: 260,
              height: 260,
            ),
            /* CircularProgressIndicator(
              color: TropigasGTColors.circleBackground,
            ), */
          );
        } /* else if (logic.cylinders.isEmpty) {
          return Center(
            child: EmptyState(
              title: 'No hay cilindros',
              message: 'No se encontraron cilindros para esta visita',
              illustration: Icon(Icons.propane_tank),
            ),
          );
        } */ else {
          return SingleChildScrollView(
            keyboardDismissBehavior: .onDrag,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isSmallMobile ? 8 : 14,
              vertical: isSmallMobile ? 14 : 18,
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: .min,
                children: [
                  SalesByDaySalePoint(
                    isSmallMobile: isSmallMobile,
                    pointSale: logic.argumentsByVisits.pointSale,
                    stripes: logic.stripes,
                    totalGoals: logic.totalGoals,
                    projected: logic.projected,
                    progressPercent: logic.calculateProgress(
                      logic.stripes,
                      logic.totalGoals,
                    ),
                    monthlyPoints: logic.monthlyCylinderSales,
                  ),
                  SaleMonthSalePoint(
                    isSmallMobile: isSmallMobile,
                    monthlyCylinderSales: logic.monthlyCylinderSales,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
