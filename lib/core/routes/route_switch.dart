// Package imports:
import 'package:material_ui/material_ui.dart';

// Project imports:
import 'package:app_supervisores_gt/core/routes/route_paths.dart';
import 'package:app_supervisores_gt/features/auth/begin/permission_page.dart';
import 'package:app_supervisores_gt/features/auth/begin/splash.dart';
import 'package:app_supervisores_gt/features/auth/check_imei/page/check_imei_page.dart';
import 'package:app_supervisores_gt/features/auth/imei/page/imei_page.dart';
import 'package:app_supervisores_gt/features/auth/login_admin/pages/login_admin_page.dart';
import 'package:app_supervisores_gt/features/auth/login_user/page/login_user_page.dart';
import 'package:app_supervisores_gt/features/checklist/page/checklist_page.dart';
import 'package:app_supervisores_gt/features/dashboard/pages/dashboard_page.dart';
import 'package:app_supervisores_gt/features/goal_sale_point/page/goal_sale_point_page.dart';
import 'package:app_supervisores_gt/features/inventory/page/inventory_page.dart';
import 'package:app_supervisores_gt/features/photo_descripcion/models/photo_arguments.dart';
import 'package:app_supervisores_gt/features/photo_descripcion/page/photo_description.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/model/arguments_by_visits.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/page/scheduled_visits_page.dart';
import 'package:app_supervisores_gt/features/settings/page/settings_page.dart';
import 'package:app_supervisores_gt/features/signature/models/signature_args.dart';
import 'package:app_supervisores_gt/features/signature/page/signature_page.dart';
import 'package:app_supervisores_gt/features/stores/pages/stores_page.dart';
import 'package:app_supervisores_gt/features/supervisor_cut/page/supervisor_cut_page.dart';

class RouteSwitch {
  static PageRouteBuilder<dynamic> _instant(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, _, _) => page,
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.splash:
        return _instant(Splash());
      case RoutePaths.permissionPage:
        return _instant(PermissionPage());
      case RoutePaths.checkImei:
        return _instant(CheckImeiPage());
      case RoutePaths.loginAdmin:
        return _instant(LoginAdminPage());
      case RoutePaths.imei:
        return _instant(ImeiPage());
      case RoutePaths.loginUser:
        return _instant(LoginUserPage());
      case RoutePaths.dashboard:
        return _instant(DashboardPage());
      case RoutePaths.assignStores:
        return _instant(StoresPage());
      case RoutePaths.presale:
        return _instant(SupervisorCutPage());
      case RoutePaths.programmedVisits:
        return _instant(ScheduledVisitsPage());
      case RoutePaths.checklist:
        final args = settings.arguments as ArgumentsByVisits;
        return _instant(ChecklistPage(args: args));
      case RoutePaths.photoDescription:
        final args = settings.arguments as PhotoArguments;
        return _instant(PhotoDescriptionPage(args: args, title: ''));
      case RoutePaths.signature:
        final args = settings.arguments as SignatureArgs;
        return _instant(SignaturePage(args: args));
      case RoutePaths.goalsByPointSale:
        final args = settings.arguments as ArgumentsByVisits;
        return _instant(GoalSalePointPage(argsVisit: args));
      case RoutePaths.inventory:
        final args = settings.arguments as ArgumentsByVisits;
        return _instant(InventoryPage(argsVisit: args));
      case RoutePaths.about:
        return _instant(SettingsPage());

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
