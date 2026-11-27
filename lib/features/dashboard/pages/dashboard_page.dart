// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/global/global_bloc.dart';
import 'package:app_supervisores_gt/features/dashboard/logic/dashboard_logic.dart';
import 'package:app_supervisores_gt/features/dashboard/pages/dashboard_layout.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_app_bar.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_bottom_navigator.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_drawer.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardLogic(
        repository: sl.get<Repository>(),
        context: context,
        global: sl.get<GlobalBloc>(),
      ),
      child: Scaffold(
        appBar: CustomAppBar(title: 'Inicio', showDrawerButton: false),
        drawer: CustomDrawer(),
        bottomNavigationBar: CustomBottomNavigator(currentIndex: 2),
        body: DashboardLayout(),
      ),
    );
  }
}
