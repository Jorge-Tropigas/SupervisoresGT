// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:tomza_kit/ui/components/tomza_empty_widget.dart';
import 'package:tomza_kit/ui/themes/colors.dart';
import 'package:tomza_kit/utils/responsive.dart';

// Project imports:
import 'package:app_supervisores_gt/features/stores/logic/stores_logic.dart';
import 'package:app_supervisores_gt/features/stores/model/enum_visit_created.dart';

class StoresLayout extends StatelessWidget {
  const StoresLayout({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = context.isMobile;

    return Consumer<StoresLogic>(
      builder: (context, logic, child) {
        if (logic.isLoading) {
          return Center(
            child: Lottie.asset(
              'assets/animations/loading_fire.json',
              height: 500,
              width: 500,
            ) /* CircularProgressIndicator(color: TropigasGTColors.primary), */,
          );
        } else if (logic.stores.isEmpty) {
          return EmptyState(
            title: 'Sin Tiendas Asignadas',
            message: 'No tienes tiendas asignadas, favor de contactar a tu administrador o Contact Center.',
            illustration: Icon(
              Icons.store,
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
                  padding: EdgeInsets.symmetric(vertical: 12),
                  itemCount: logic.stores.length,
                  itemBuilder: (context, index) {
                    final store = logic.stores[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => logic.createVisit(store),
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
                                // Icono o Foto de la tienda
                                CircleAvatar(
                                  backgroundColor: TropigasGTColors.primary,
                                  child: Text(store.pointSale[0].toUpperCase()),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      // Nombre de la tienda
                                      Row(
                                        mainAxisAlignment: .spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              'Tienda: ${store.description}',
                                              maxLines:
                                                  store.description.length > 11
                                                  ? 2
                                                  : 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.gabarito(
                                                fontSize: 14,
                                                fontWeight: .bold,
                                              ),
                                            ),
                                          ),
                                          // ESTADO DE LA VISITA
                                          store.visitStatus.name ==
                                                  EnumVisitCreated.created.name
                                              ? Chip(
                                                  label: Text(
                                                    store.visitStatus.name,
                                                    style: GoogleFonts.gabarito(
                                                      fontSize: 14,
                                                      fontWeight: .bold,
                                                      color: store
                                                          .visitStatus
                                                          .color,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox.shrink(),
                                        ],
                                      ),
                                      Text(
                                        store.phone != null &&
                                                store.phone!.isNotEmpty
                                            ? 'Tel. ${store.phone}'
                                            : 'Tel. No disponible',
                                        style: GoogleFonts.gabarito(
                                          fontSize: 14,
                                          fontWeight: .bold,
                                        ),
                                      ),
                                      Text(
                                        store.employeeName != null &&
                                                store.employeeName!.isNotEmpty
                                            ? 'Empleado: ${store.employeeName}'
                                            : 'Sin Empleado Asignado',
                                        style: GoogleFonts.gabarito(
                                          fontSize: 14,
                                          fontWeight: .bold,
                                        ),
                                      ),

                                      // ESTADO DE LA VISITA
                                      /* store.visitStatus.name ==
                                              EnumVisitCreated.created.name
                                          ? Text(
                                              store.visitStatus.name,
                                              style: GoogleFonts.gabarito(
                                                fontSize: 14,
                                                fontWeight: .bold,
                                                color: store.visitStatus.color,
                                              ),
                                            )
                                          : SizedBox.shrink(), */
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
