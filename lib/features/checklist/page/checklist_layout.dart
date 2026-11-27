// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:tomza_kit/tomza_kit.dart';
import 'package:tomza_kit/ui/components/tomza_empty_widget.dart';

// Project imports:
import 'package:app_supervisores_gt/core/routes/route_paths.dart';
import 'package:app_supervisores_gt/features/checklist/logic/checklist_logic.dart';
import 'package:app_supervisores_gt/features/checklist/widgets/status_pill.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/model/enum_visit_status.dart';
import 'package:app_supervisores_gt/features/signature/models/signature_args.dart';

class ChecklistLayout extends StatelessWidget {
  const ChecklistLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Consumer<ChecklistLogic>(
      builder: (context, logic, child) {
        if (logic.isLoading) {
          return Center(
            child: Lottie.asset(
              'assets/animations/loading_fire.json',
              width: 260,
              height: 260,
            ) /* CircularProgressIndicator(
              color: TropigasGTColors.circleBackground,
            ), */,
          );
        } else if (logic.typeIncident.isEmpty) {
          return EmptyState(
            title: '',
            message: 'No se encontro información',
            illustration: Icon(Icons.fact_check_outlined),
          );
        } else {
          return Column(
            children: [
              ListView.builder(
                itemCount: logic.typeIncident.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (_, index) {
                  final type = logic.typeIncident[index];
                  final newItem = logic.listItems[index];

                  return GestureDetector(
                    onTap: () => logic.validVisitStatus(
                      context,
                      logic.args.visitId,
                      newItem.label,
                      newItem,
                      type.typeIncident,
                    ),
                    child: Card(
                      elevation: 4,
                      margin: EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: .start,
                          mainAxisAlignment: .center,
                          mainAxisSize: .max,
                          children: [
                            SizedBox(width: 8),
                            CircleAvatar(
                              backgroundColor:
                                  TropigasGTColors.circleBackground,
                              child: Icon(
                                newItem.icon,
                                size: 24,
                                color: TropigasGTColors.layout,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                newItem.label,
                                style: GoogleFonts.gabarito(fontSize: 18),
                              ),
                            ),
                            SizedBox(width: 8),
                            StatusPill(
                              color: logic.statusColor(
                                logic.statusFor(newItem.label),
                                theme,
                              ),
                              label: logic.statusLabel(
                                logic.statusFor(newItem.label),
                              ),
                              done:
                                  logic.statusFor(newItem.label) ==
                                  EnumVisitStatus.complete,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 8),
              logic.listItems.every(
                    (element) =>
                        logic.statusFor(element.label) ==
                        EnumVisitStatus.complete,
                  )
                  ? TomzaPrimaryButton(
                      label: 'Cerrar Visita',
                      fontWeight: .bold,
                      icon: Icons.save_as,
                      onPressed: () => Navigator.pushNamed(
                        context,
                        RoutePaths.signature,
                        arguments: SignatureArgs(visitId: logic.args.visitId),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          );
        }
      },
    );
  }
}
