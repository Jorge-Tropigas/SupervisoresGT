// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/features/drawer/drawer_items.dart';
import 'package:tomza_kit/utils/responsive.dart';

// Project imports:
import 'package:app_supervisores_gt/core/routes/route_paths.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    String? currentRoute = ModalRoute.of(context)?.settings.name;

    bool isTablet = context.isTablet;

    ThemeData theme = Theme.of(context);
    Color backgroundColor =
        theme.drawerTheme.backgroundColor ??
        (theme.brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : const Color(0xFFF8F9FA));

    List<Widget> drawerItems = _buildDrawerItems(context, currentRoute);

    return SafeArea(
      child: Drawer(
        backgroundColor: backgroundColor,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double estimatedItemHeight = isTablet ? 70.0 : 60.0;
            double estimatedContentHeight =
                drawerItems.length * estimatedItemHeight;
            double footerHeight = 160.0;
            double headerHeight = 160.0;
            double availableHeight =
                constraints.maxHeight - footerHeight - headerHeight;

            bool needsScroll = estimatedContentHeight > availableHeight;

            return Column(
              children: <Widget>[
                /// HEADER
                Container(
                  height: headerHeight,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/fondo_barco.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Divider(height: 1),

                /// ITEMS
                if (needsScroll)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: drawerItems),
                    ),
                  )
                else
                  ...drawerItems,

                const Spacer(),
                const Divider(height: 1),

                /// FOOTER
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/logo_name.png',
                        width: isTablet ? 455 : 245,
                        height: isTablet ? 225 : 65,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Versión 2.0.1',
                        /* ${/* context.watch<GlobalBloc>().version */} */
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildDrawerItems(BuildContext context, String? currentRoute) {
    return <Widget>[
      DrawerItems(
        context: context,
        title: 'Principal',
        icon: Icons.home,
        route: RoutePaths.dashboard,
        currentRoute: currentRoute,
        onTap: () {
          Navigator.pop(context); // Cierra el Drawer
          Navigator.pushNamed(context, RoutePaths.dashboard);
        },
      ),
      DrawerItems(
        context: context,
        title: 'Tiendas Asignadas',
        icon: Icons.store_outlined,
        route: RoutePaths.assignStores,
        currentRoute: currentRoute,
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, RoutePaths.assignStores);
        },
      ),
      DrawerItems(
        context: context,
        title: 'Corte Supervisor',
        icon: Icons.shopping_cart_outlined,
        route: RoutePaths.presale,
        currentRoute: currentRoute,
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, RoutePaths.presale);
        },
      ),
      DrawerItems(
        context: context,
        title: 'Visitas Programadas',
        icon: Icons.schedule_outlined,
        route: RoutePaths.programmedVisits,
        currentRoute: currentRoute,
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, RoutePaths.programmedVisits);
        },
      ),
      DrawerItems(
        context: context,
        title: 'Acerca de',
        icon: Icons.info_outline_rounded,
        route: RoutePaths.about,
        currentRoute: currentRoute,
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, RoutePaths.about);
        },
      ),
    ];
  }
}
