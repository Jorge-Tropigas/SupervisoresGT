// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/ui/themes/colors.dart';

// Project imports:
import 'package:app_supervisores_gt/features/scheduled_visits/model/schedule_visits.dart';

class ScheduledVisitCard extends StatelessWidget {
  const ScheduledVisitCard({
    super.key,
    required this.scheduleVisit,
    required this.statusColor,
    required this.statusTextColor,
    required this.onTap,
  });

  final ScheduleVisits scheduleVisit;
  final Color statusColor;
  final Color statusTextColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: TropigasGTColors.swipeListItem,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  child: Text(scheduleVisit.pointSale[0].toUpperCase()),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      scheduleVisit.description,
                      style: GoogleFonts.gabarito(
                        fontSize: 18,
                        fontWeight: .bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 15),
                        SizedBox(width: 4),
                        Text(
                          scheduleVisit.dateVisit,
                          style: GoogleFonts.gabarito(
                            fontSize: 15,
                            fontWeight: .normal,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.pending_actions, size: 15),
                        SizedBox(width: 4),
                        Chip(
                          elevation: 4,
                          backgroundColor: statusColor,
                          label: Text(
                            scheduleVisit.statusDescription,
                            style: GoogleFonts.gabarito(
                              fontSize: 16,
                              fontWeight: .normal,
                              color: statusTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
