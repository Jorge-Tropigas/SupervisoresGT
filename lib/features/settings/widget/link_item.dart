// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/ui/themes/colors.dart';

class LinkItem extends StatelessWidget {
  const LinkItem({
    required this.label,
    required this.icon,
    this.onTap,
    this.subtitle,
    this.labelFontSize = 15,
    super.key,
  });

  final String label;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final double labelFontSize;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: TropigasGTColors.circleBackground.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: TropigasGTColors.primaryDark),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.gabarito(
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w600,
                    color: TropigasGTColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: GoogleFonts.gabarito(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: TropigasGTColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: Colors.grey.shade400,
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return content;

    return InkWell(onTap: onTap, child: content);
  }
}
