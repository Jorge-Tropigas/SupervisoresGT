// Package imports:
import 'package:lottie/lottie.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:tomza_kit/ui/components/tomza_empty_widget.dart';
import 'package:tomza_kit/ui/themes/colors.dart';
import 'package:tomza_kit/utils/responsive.dart';

// Project imports:
import 'package:app_supervisores_gt/features/scheduled_visits/logic/scheduled_visits_logic.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/model/date_filter.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/model/enum_visit_status.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/widgets/quick_filter.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/widgets/scheduled_visit_card.dart';

class ScheduledVisitsLayout extends StatelessWidget {
  const ScheduledVisitsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = context.isMobile;

    return Consumer<ScheduledVisitsLogic>(
      builder: (context, logic, _) {
        if (logic.isLoading) {
          return Center(
            child: Lottie.asset(
              'assets/animations/loading_fire.json',
              height: 500,
              width: 500,
            ) /* CircularProgressIndicator(color: TropigasGTColors.primary), */,
          );
        } else if (logic.scheduledVisits.isEmpty) {
          return Column(
            children: [
              QuickFilters(
                isMobile: isMobile,
                current: logic.selectedFilter,
                onSelect: (DateFilter f) => logic.setDateFilter(f),
                onCustom: () async {
                  DateTime today = DateTime.now();
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: logic.customDate ?? today,
                    firstDate: today.subtract(const Duration(days: 30)),
                    lastDate: today.add(const Duration(days: 60)),
                    locale: const Locale('es'),
                  );
                  if (picked != null) {
                    logic.setCustomDate(picked);
                  }
                },
              ),
              Expanded(
                child: Center(
                  child: EmptyState(
                    title: 'No se encontraron Visitas Programadas',
                    message: 'Intenta programar una visita en el boton flotante o cambia la fecha a visitar',
                    illustration: Icon(
                      Icons.access_time,
                      fontWeight: FontWeight.normal,
                      color: TropigasGTColors.primary,
                      size: 45,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 16,
              vertical: isMobile ? 8 : 12,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? double.infinity : 700,
                ),
                child: Column(
                  children: [
                    QuickFilters(
                      isMobile: isMobile,
                      current: logic.selectedFilter,
                      onSelect: (DateFilter f) => logic.setDateFilter(f),
                      onCustom: () async {
                        DateTime today = DateTime.now();
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: logic.customDate ?? today,
                          firstDate: today.subtract(const Duration(days: 30)),
                          lastDate: today.add(const Duration(days: 60)),
                          locale: const Locale('es'),
                        );
                        if (picked != null) {
                          logic.setCustomDate(picked);
                        }
                      },
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      itemCount: logic.scheduledVisits.length,
                      itemBuilder: (context, index) {
                        final scheduleVisit = logic.scheduledVisits[index];

                        final visitStatus = EnumVisitStatus.fromDescription(
                          scheduleVisit.statusDescription,
                        );

                        return ScheduledVisitCard(
                          scheduleVisit: scheduleVisit,
                          statusColor: visitStatus.color,
                          statusTextColor: visitStatus.colorText,
                          onTap: () => logic.showModalOptionsVisit(
                            scheduleVisit,
                            context,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
