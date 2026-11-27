// Package imports:
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/ui/themes/colors.dart';
import 'package:tomza_kit/utils/responsive.dart';

// Project imports:
import 'package:app_supervisores_gt/core/routes/route_paths.dart';

class CustomBottomNavigator extends StatefulWidget {
  const CustomBottomNavigator({
    required this.currentIndex,
    super.key,
    this.kIconSize = 28,
    this.kBottomRadius = 24,
  });

  final double kIconSize;
  final double kBottomRadius;
  final int currentIndex;

  @override
  State<CustomBottomNavigator> createState() => _CustomBottomNavigatorState();
}

class _CustomBottomNavigatorState extends State<CustomBottomNavigator> {
  late NotchBottomBarController _controller;
  int _visualIndex = 0;

  static const _routes = [
    RoutePaths.presale,
    RoutePaths.programmedVisits,
    RoutePaths.dashboard,
    RoutePaths.assignStores,
    RoutePaths.about,
  ];

  @override
  void initState() {
    super.initState();
    _visualIndex = widget.currentIndex;
    _controller = NotchBottomBarController(index: _visualIndex);
  }

  @override
  void didUpdateWidget(CustomBottomNavigator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      setState(() {
        _visualIndex = widget.currentIndex;
        _controller.index = widget.currentIndex;
      });
    }
  }

  void _onTabTapped(int index) {
    if (widget.currentIndex == index || index < 0 || index >= _routes.length) {
      return;
    }

    setState(() {
      _visualIndex = index;
      _controller.index = index;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, _routes[index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallMobile = context.isSmallMobile;
    final screenWidth = isSmallMobile
        ? MediaQuery.sizeOf(context).width * 0.89
        : MediaQuery.sizeOf(context).width;
    // final bottomBarWidth = (screenWidth - 16).clamp(340.0, 480.0);
    final bottomBarWidth = screenWidth;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isCompact = screenWidth < 400;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: SafeArea(
        top: false,
        child: AnimatedNotchBottomBar(
          color: TropigasGTColors.circleBackground,
          /* notchGradient: LinearGradient(
            colors: [TropigasGTColors.primary, TropigasGTColors.primaryDark],
          ), */
          showLabel: true,
          notchBottomBarController: _controller,
          bottomBarWidth: bottomBarWidth,
          bottomBarHeight: screenHeight * 0.08,
          bottomBarItems: [
            _buildItem(Icons.shopping_cart_outlined, 'CORTE SUPERVISOR'),
            // _buildItem(Icons.person_search_rounded, 'CLIENTES'),
            _buildItem(Icons.schedule_outlined, 'VISITAS'),
            _buildItem(Icons.home, 'INICIO'),
            _buildItem(Icons.store_outlined, 'TIENDAS'),
            _buildSvgItem('assets/images/chatbot_icon.png', 'SOPORTE'),
          ],
          onTap: _onTabTapped,
          kIconSize: isCompact ? 22.0 : widget.kIconSize,
          kBottomRadius: isCompact ? 18.0 : widget.kBottomRadius,
          shadowElevation: 8,
          notchColor: TropigasGTColors.white,
        ),
      ),
    );
  }

  /* BottomBarItem _buildItem(IconData icon, String label) {
    return BottomBarItem(
      inActiveItem: Icon(icon, color: TropigasGTColors.white.withValues(alpha: 0.7)), */
  BottomBarItem _buildItem(IconData? icon, String label) {
    return BottomBarItem(
      inActiveItem: Icon(
        icon,
        color: TropigasGTColors.white.withValues(alpha: 0.7),
      ),
      activeItem: Icon(icon, color: TropigasGTColors.primary),
      itemLabelWidget: SizedBox(
        width: 76,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            softWrap: false,
            style: GoogleFonts.gabarito(
              color: TropigasGTColors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  BottomBarItem _buildSvgItem(String assetPath, String label) {
    return BottomBarItem(
      inActiveItem: Image.asset(
        assetPath,
        color: TropigasGTColors.white.withValues(alpha: 0.7),
        width: 24,
        height: 24,
      ),
      activeItem: Image.asset(
        assetPath,
        color: TropigasGTColors.primary,
        width: 24,
        height: 24,
      ),
      itemLabelWidget: SizedBox(
        width: 76,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            softWrap: false,
            style: GoogleFonts.gabarito(
              color: TropigasGTColors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
