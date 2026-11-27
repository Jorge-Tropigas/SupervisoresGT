// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/global/global_bloc.dart';
import 'package:app_supervisores_gt/features/stores/logic/stores_logic.dart';
import 'package:app_supervisores_gt/features/stores/pages/stores_layout.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_app_bar.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_bottom_navigator.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_drawer.dart';

class StoresPage extends StatelessWidget {
  const StoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StoresLogic(
        context: context,
        repository: sl.get<Repository>(),
        global: sl.get<GlobalBloc>(),
      ),
      child: const Scaffold(
        appBar: CustomAppBar(
          title: 'Tiendas Asignadas',
          showDrawerButton: false,
        ),
        drawer: CustomDrawer(),
        bottomNavigationBar: CustomBottomNavigator(currentIndex: 3),
        body: StoresLayout(),
      ),
    );
  }
}
