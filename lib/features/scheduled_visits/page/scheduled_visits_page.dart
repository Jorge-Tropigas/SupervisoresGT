// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:tomza_kit/ui/themes/colors.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/global/global_bloc.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/logic/scheduled_visits_logic.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/page/scheduled_visits_layout.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_app_bar.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_bottom_navigator.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_drawer.dart';

class ScheduledVisitsPage extends StatelessWidget {
  const ScheduledVisitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScheduledVisitsLogic(
        repository: sl.get<Repository>(),
        global: sl.get<GlobalBloc>(),
      ),
      child: Consumer<ScheduledVisitsLogic>(
        builder: (context, logic, child) => Scaffold(
          appBar: CustomAppBar(
            title: 'Visitas Programadas',
            showDrawerButton: false,
          ),
          drawer: CustomDrawer(),
          bottomNavigationBar: CustomBottomNavigator(currentIndex: 1),
          body: ScheduledVisitsLayout(),
          floatingActionButton: FloatingActionButton.small(
            onPressed: () => logic.showAddVisitModal(context),
            backgroundColor: TropigasGTColors.circleBackground,
            elevation: 8,
            tooltip: 'Crear Visita',
            child: Icon(Icons.add, color: TropigasGTColors.layout, size: 32),
          ),
        ),
      ),
    );
  }
}
