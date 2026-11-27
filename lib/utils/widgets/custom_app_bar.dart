// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/ui/themes/colors.dart';
import 'package:tomza_kit/utils/responsive.dart';

// Project imports:
import 'package:app_supervisores_gt/features/auth/login_user/page/login_user_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.title,
    super.key,
    this.showDrawerButton = false,
    this.showBackButton = false,
    this.iconData,
    this.onDrawerPressed,
    this.onBackPressed,
    this.onTap,
  });

  final String title;
  final bool showDrawerButton;
  final bool showBackButton;
  final IconData? iconData;
  final VoidCallback? onDrawerPressed;
  final VoidCallback? onBackPressed;
  final VoidCallback? onTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;
    final double toolbarHeight = isMobile ? kToolbarHeight : 80.0;
    final double fontSize = isMobile ? 18 : 28;
    final double iconSize = isMobile ? 24 : 28;

    return AppBar(
      toolbarHeight: toolbarHeight,
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: TropigasGTColors.circleBackground,
          /* gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [TropigasGTColors.primary, TropigasGTColors.primaryDark],
          ), */
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: TropigasGTColors.primaryDark.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      leading: showDrawerButton && isMobile
          ? IconButton(
              icon: Icon(
                Icons.menu_rounded,
                size: iconSize,
                color: TropigasGTColors.white,
              ),
              onPressed:
                  onDrawerPressed ?? () => Scaffold.of(context).openDrawer(),
            )
          : (showBackButton
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: iconSize,
                      color: TropigasGTColors.white,
                    ),
                    onPressed: onBackPressed ?? () => Navigator.pop(context),
                  )
                : SizedBox.shrink()),
      title: Text(
        title,
        style: GoogleFonts.gabarito(
          color: TropigasGTColors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: true,
      actions: <Widget>[
        if (iconData != null)
          IconButton(
            onPressed: onTap,
            icon: Icon(iconData, size: iconSize, color: TropigasGTColors.white),
          ),

        IconButton(
          icon: Icon(
            Icons.logout_rounded,
            size: iconSize,
            color: TropigasGTColors.white,
          ),
          tooltip: 'Cerrar sesión',
          onPressed: () => _logout(context),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      // await sl.get<GlobalBloc>().clearAllSessionData();
    } catch (_) {}
    try {
      // AuthTokenStore.instance.clear();
    } catch (_) {}
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginUserPage(),
        ),
        (Route route) => false,
      );
    }
  }
}
