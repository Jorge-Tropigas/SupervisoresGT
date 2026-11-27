// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/features/inventory/logic/inventory_logic.dart';
import 'package:app_supervisores_gt/features/inventory/page/inventory_layout.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/model/arguments_by_visits.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';
import 'package:app_supervisores_gt/utils/widgets/custom_app_bar.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key, required this.argsVisit});

  final ArgumentsByVisits argsVisit;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InventoryLogic>(
      create: (context) =>
          InventoryLogic(args: argsVisit, repository: sl.get<Repository>()),
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Inventario ${argsVisit.pointSaleName}',
          showBackButton: true,
        ),
        body: InventoryLayout(),
      ),
    );
  }
}
