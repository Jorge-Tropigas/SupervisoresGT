// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:tomza_kit/tomza_kit.dart';
import 'package:tomza_kit/ui/components/tomza_empty_widget.dart';

// Project imports:
import 'package:app_supervisores_gt/features/supervisor_cut/logic/supervisor_cut_logic.dart';

class SupervisorCutPreventaLayout extends StatelessWidget {
  const SupervisorCutPreventaLayout({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = context.isMobile;

    return Consumer<SupervisorCutLogic>(
      builder: (context, logic, child) {
        if (logic.isLoading) {
          return Center(
            child: Lottie.asset(
              'assets/animations/loading_fire.json',
              width: 260,
              height: 260,
            ) /* CircularProgressIndicator(color: TropigasGTColors.primary), */,
          );
        } else if (logic.supervisorCuts.isEmpty) {
          return EmptyState(
            title: 'Sin Cortes Pendientes',
            message: 'Crea un nuevo token para generar cortes pendientes',
            illustration: Icon(
              Icons.pending_actions_rounded,
              fontWeight: FontWeight.normal,
              color: TropigasGTColors.primary,
              size: 45,
            ),
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
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: logic.supervisorCuts.length,
                  itemBuilder: (context, index) {
                    final cut = logic.supervisorCuts[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: TropigasGTColors.swipeListItem,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: TropigasGTColors.primary,
                                child: Text(cut.description[0].toUpperCase()),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: .start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.description_outlined,
                                          size: 20,
                                          color: TropigasGTColors.primary,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Descripcion: ${cut.description}',
                                            style: GoogleFonts.gabarito(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.point_of_sale_outlined,
                                          size: 20,
                                          color: TropigasGTColors.primary,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'PDV: ${cut.deliveryPDV}',
                                          style: GoogleFonts.gabarito(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.money_outlined,
                                          size: 20,
                                          color: TropigasGTColors.primary,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Total Corte: Q. ${cut.cutTotal}',
                                          style: GoogleFonts.gabarito(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    /* Row(
                                      children: [
                                        Icon(
                                          Icons.money_outlined,
                                          size: 20,
                                          color: TropigasGTColors.primary,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Token Supervisor: ${cut.supervisorToken}',
                                          style: GoogleFonts.gabarito(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8), */
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          size: 20,
                                          color: TropigasGTColors.primary,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Dia: ${cut.date}',
                                          style: GoogleFonts.gabarito(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.description_outlined,
                                          size: 20,
                                          color: TropigasGTColors.primary,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Estado: ${cut.cutAuthStatusDescription}',
                                          style: GoogleFonts.gabarito(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),

                                    Row(
                                      mainAxisAlignment: .end,
                                      children: [
                                        /* TomzaTextButton(
                                          label: 'Rechazar',
                                          textColor: TropigasGTColors.error,
                                          onPressed: () => showInfo(
                                            'Boton Cancelar Implementar',
                                          ),
                                        ), */
                                        TomzaPrimaryButton(
                                          label: 'Rechazar',
                                          onPressed: () => logic
                                              .acceptRejectCut(cut, null, 2),
                                        ),
                                        SizedBox(width: 12),
                                        TomzaPrimaryButton(
                                          label: 'Aceptar',
                                          onPressed: () => logic
                                              .acceptRejectCut(cut, null, 1),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
