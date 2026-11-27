// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/ui/themes/status_color.dart';

// Project imports:
import 'package:app_supervisores_gt/utils/utils/card_app.dart';

class ProgressInfo extends StatelessWidget {
  const ProgressInfo({
    super.key,
    required this.progressValue,
    required this.isMobile,
  });

  final double progressValue;
  final bool isMobile;
  final double totalGoals = 0;
  final double stripes = 0;

  @override
  Widget build(BuildContext context) {
    double remaining = (totalGoals) - (stripes);
    AppStatusColors? status = Theme.of(context).extension<AppStatusColors>();
    Color success = status?.success ?? Colors.green;
    Color warning = status?.warning ?? Colors.orange;
    Color danger = status?.danger ?? Colors.red;

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (progressValue >= 0.85) {
      statusColor = success;
      statusText = 'En meta';
      statusIcon = Icons.trending_up;
    } else if (progressValue >= 0.65) {
      statusColor = warning;
      statusText = 'En camino';
      statusIcon = Icons.trending_flat;
    } else {
      statusColor = danger;
      statusText = 'Por debajo';
      statusIcon = Icons.trending_down;
    }

    return CardApp(
      padding: EdgeInsets.all(isMobile ? 8 : 12),
      borderRadius: isMobile ? 10 : 12,
      variant: AppCardVariant.outlined,
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'Faltan: ${remaining.toStringAsFixed(1)} gal.',
                style: GoogleFonts.alexandria(
                  fontSize: isMobile ? 11 : 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                'Progreso: ${(progressValue * 100).toStringAsFixed(1)}%',
                style: GoogleFonts.alexandria(
                  fontSize: isMobile ? 10 : 11,
                  color: Theme.of(context).colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(statusIcon, color: statusColor, size: isMobile ? 16 : 18),
              SizedBox(width: isMobile ? 4 : 6),
              Text(
                statusText,
                style: GoogleFonts.alexandria(
                  fontSize: isMobile ? 10 : 11,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
