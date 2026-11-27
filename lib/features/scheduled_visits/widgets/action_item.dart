// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/utils/responsive.dart';

class ActionItem extends StatelessWidget {
  const ActionItem({
    required this.context,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    super.key,
  });

  final BuildContext context;
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: isMobile ? 80 : 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: isMobile ? 56 : 64,
              height: isMobile ? 56 : 64,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Icon(icon, color: color, size: isMobile ? 28 : 32),
            ),
            SizedBox(height: isMobile ? 8 : 12),
            Text(
              label,
              style: TextStyle(
                fontSize: isMobile ? 12 : 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
