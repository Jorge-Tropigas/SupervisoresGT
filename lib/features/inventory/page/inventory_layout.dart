// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:tomza_kit/ui/components/tomza_button.dart';
import 'package:tomza_kit/ui/components/tomza_empty_widget.dart';
import 'package:tomza_kit/ui/themes/colors.dart';
import 'package:tomza_kit/utils/responsive.dart';

// Project imports:
import 'package:app_supervisores_gt/features/inventory/logic/inventory_logic.dart';
import 'package:app_supervisores_gt/features/inventory/widgets/inventory_table.dart';

class InventoryLayout extends StatelessWidget {
  const InventoryLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallMobile = context.isSmallMobile;

    return Consumer<InventoryLogic>(
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
        } else if (logic.listInventory.isEmpty) {
          return Center(
            child: EmptyState(
              title: 'No hay Inventario',
              message: 'No hay inventario registrado para este punto de venta',
              illustration: const Icon(Icons.inventory_2_outlined),
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallMobile ? 8 : 16,
              vertical: isSmallMobile ? 4 : 8,
            ),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            'Punto de Venta:',
                            style: GoogleFonts.gabarito(
                              fontSize: isSmallMobile ? 14 : 16,
                              fontWeight: .bold,
                              color: TropigasGTColors.textPrimary,
                            ),
                          ),
                          Text(
                            logic.args.pointSaleName ?? 'No Disponible',
                            style: GoogleFonts.gabarito(
                              fontSize: isSmallMobile ? 14 : 16,
                              fontWeight: .bold,
                              color: TropigasGTColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Refrescar',
                      icon: Icon(
                        Icons.refresh_rounded,
                        size: isSmallMobile ? 20 : 24,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height: isSmallMobile ? 12 : 16),
                InventoryTable(
                  listInventory: logic.listInventory,
                  onTap: (item) => logic.updateInventory(context, item),
                ),
                SizedBox(height: isSmallMobile ? 12 : 16),
                TomzaPrimaryButton(
                  label: 'Guardar',
                  fontSize: isSmallMobile ? 14 : 18,
                  color: TropigasGTColors.circleBackground,
                  height: isSmallMobile ? 40 : 48,
                  fontWeight: .bold,
                  icon: Icons.save_as,
                  onPressed: () => logic.createUpdateInventory(context),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
