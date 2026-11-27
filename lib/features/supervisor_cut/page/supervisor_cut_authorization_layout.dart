// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:tomza_kit/ui/components/tomza_button.dart';
import 'package:tomza_kit/ui/components/tomza_empty_widget.dart';
import 'package:tomza_kit/ui/themes/colors.dart';
import 'package:tomza_kit/utils/responsive.dart';

// Project imports:
import 'package:app_supervisores_gt/features/supervisor_cut/logic/supervisor_cut_logic.dart';

class SupervisorCutAuthorizationLayout extends StatelessWidget {
  const SupervisorCutAuthorizationLayout({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = context.isMobile;

    return Consumer<SupervisorCutLogic>(
      builder: (context, logic, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: InkWell(
                onTap: () => logic.showSupervisorFilterDialog(),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: TropigasGTColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: TropigasGTColors.layoutBorder),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.filter_list, color: TropigasGTColors.primary),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          logic.selectedSupervisorUser != null
                              ? 'Supervisor: ${logic.selectedSupervisorUser}'
                              : 'Filtrar por Supervisor',
                          style: GoogleFonts.gabarito(fontSize: 14),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: TropigasGTColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: _buildContent(logic, isMobile)),
          ],
        );
      },
    );
  }

  Widget _buildContent(SupervisorCutLogic logic, bool isMobile) {
    if (logic.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: TropigasGTColors.primary),
      );
    } else if (logic.pendingAuth.isEmpty) {
      return EmptyState(
        title: 'Sin Autorizaciones Pendientes',
        message: logic.selectedSupervisorUser == null
            ? 'Seleccione un supervisor para ver autorizaciones pendientes'
            : 'No hay autorizaciones pendientes',
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
              itemCount: logic.pendingAuth.length,
              itemBuilder: (context, index) {
                final authCut = logic.pendingAuth[index];

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
                            child: Text(
                              authCut.salePoint.isNotEmpty
                                  ? authCut.salePoint[0].toUpperCase()
                                  : '?',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.document_scanner,
                                      size: 20,
                                      color: TropigasGTColors.toolBar,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Corte #${authCut.cutId}',
                                        style: GoogleFonts.gabarito(
                                          fontSize: 18,
                                          fontWeight: .bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      size: 20,
                                      color: TropigasGTColors.toolBar,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Visita #${authCut.visit}',
                                        style: GoogleFonts.gabarito(
                                          fontSize: 18,
                                          fontWeight: .bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person_rounded,
                                      size: 20,
                                      color: TropigasGTColors.toolBar,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Supervisor: ${authCut.supervisor}',
                                        style: GoogleFonts.gabarito(
                                          fontSize: 18,
                                          fontWeight: .bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person_pin_circle,
                                      size: 20,
                                      color: TropigasGTColors.toolBar,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Usuario de Tienda: ${authCut.storeUser}',
                                        style: GoogleFonts.gabarito(
                                          fontSize: 18,
                                          fontWeight: .bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.store_mall_directory_outlined,
                                      size: 20,
                                      color: TropigasGTColors.toolBar,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Punto de Venta: ${authCut.salePoint}',
                                        style: GoogleFonts.gabarito(
                                          fontSize: 18,
                                          fontWeight: .bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: .end,
                                  children: [
                                    TomzaTextButton(
                                      label: 'Diferencias',
                                      textColor: TropigasGTColors.primary,
                                      fontSize: 12,
                                      fontWeight: .normal,
                                      onPressed: () =>
                                          logic.viewDifferences(authCut),
                                    ),
                                    TomzaTextButton(
                                      label: 'Rechazar',
                                      textColor: TropigasGTColors.error,
                                      fontSize: 12,
                                      fontWeight: .normal,
                                      onPressed: () =>
                                          logic.showRejectAuthDialog(authCut),
                                    ),
                                    TomzaTextButton(
                                      label: 'Aceptar',
                                      textColor:
                                          TropigasGTColors.focusedEditTxt,
                                      onPressed: () =>
                                          logic.showAcceptAuthDialog(authCut),
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
  }
}
