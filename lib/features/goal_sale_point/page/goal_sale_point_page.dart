// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/features/goal_sale_point/logic/goal_sale_point_logic.dart';
import 'package:app_supervisores_gt/features/goal_sale_point/page/goal_sale_point_layout.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/model/arguments_by_visits.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_app_bar.dart';

class GoalSalePointPage extends StatelessWidget {
  const GoalSalePointPage({super.key, required this.argsVisit});

  final ArgumentsByVisits argsVisit;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoalSalePointLogic(
        argumentsByVisits: argsVisit,
        repository: sl.get<Repository>(),
      ),
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Metas/Proyecciones ${argsVisit.pointSaleName}',
          showBackButton: true,
        ),
        body: GoalSalePointLayout(),
      ),
    );
  }
}
