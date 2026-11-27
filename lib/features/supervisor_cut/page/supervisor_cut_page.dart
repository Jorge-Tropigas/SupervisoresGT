// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:tomza_kit/ui/themes/colors.dart';
import 'package:tomza_kit/utils/responsive.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/global/global_bloc.dart';
import 'package:app_supervisores_gt/features/supervisor_cut/logic/supervisor_cut_logic.dart';
import 'package:app_supervisores_gt/features/supervisor_cut/page/supervisor_cut_authorization_layout.dart';
import 'package:app_supervisores_gt/features/supervisor_cut/page/supervisor_cut_preventa_layout.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_app_bar.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_bottom_navigator.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_drawer.dart';

class SupervisorCutPage extends StatefulWidget {
  const SupervisorCutPage({super.key});

  @override
  State<SupervisorCutPage> createState() => _SupervisorCutPageState();
}

class _SupervisorCutPageState extends State<SupervisorCutPage>
    with SingleTickerProviderStateMixin {
  static const _tabTypes = ['P', 'AP'];

  late final TabController _tabController;
  late final SupervisorCutLogic _logic;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTypes.length, vsync: this)
      ..addListener(_handleTabChange);
    _logic = SupervisorCutLogic(
      context: context,
      repository: sl.get<Repository>(),
      global: sl.get<GlobalBloc>(),
    );
    _logic.onNavigateToAuthorizationTab = () {
      final invoicedTabIndex = _tabTypes.indexOf('AP');
      if (_tabController.index != invoicedTabIndex) {
        _tabController.animateTo(invoicedTabIndex);
      } else {
        _logic.loadCuts('AP');
      }
    };
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      _logic.loadCuts(_tabTypes[_tabController.index]);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallMobile = context.isSmallMobile;

    return ChangeNotifierProvider.value(
      value: _logic,
      builder: (context, _) => Scaffold(
        appBar: CustomAppBar(
          title: 'Corte Supervisor',
          showDrawerButton: false,
        ),
        drawer: CustomDrawer(),
        bottomNavigationBar: CustomBottomNavigator(currentIndex: 0),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Center(
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: TropigasGTColors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: isSmallMobile ? true : false,
                    tabAlignment: TabAlignment.center,
                    tabs: [
                      Tab(text: 'Preventa'),
                      Tab(text: 'Autorizaciones Pendientes'),
                    ],
                    padding: const EdgeInsets.all(4.0),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: TropigasGTColors.white,
                      border: Border.all(
                        color: TropigasGTColors.button,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelColor: TropigasGTColors.focusedEditTxt,
                    unselectedLabelColor: TropigasGTColors.textPrimary
                        .withValues(alpha: 0.5),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  SupervisorCutPreventaLayout(),
                  SupervisorCutAuthorizationLayout(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.small(
          onPressed: () =>
              context.read<SupervisorCutLogic>().showCreateToken(context),
          elevation: 8,
          tooltip: 'Crear Token',
          backgroundColor: TropigasGTColors.primary,
          child: Icon(Icons.add, color: TropigasGTColors.layout, size: 26),
        ),
      ),
    );
  }
}
