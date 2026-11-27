// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/ui/themes/colors.dart';

class InfoSection extends StatelessWidget {
  const InfoSection({
    required this.title,
    required this.icon,
    required this.items,
    super.key,
  });

  final String title;
  final IconData icon;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: TropigasGTColors.primary),
            const SizedBox(width: 12),
            Text(
              title.toUpperCase(),
              style: GoogleFonts.gabarito(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: TropigasGTColors.primary,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: TropigasGTColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: TropigasGTColors.textPrimary.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Material(
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  items[i],
                  if (i != items.length - 1)
                    Divider(
                      height: 1,
                      indent: 72,
                      endIndent: 16,
                      color: Colors.grey.shade100,
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
