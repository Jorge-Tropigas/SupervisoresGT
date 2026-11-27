// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

// Project imports:
import 'package:app_supervisores_gt/features/inventory/models/inventory.dart';

class CreateUpdateInventoryRequest {
  CreateUpdateInventoryRequest({
    required this.visitId,
    required this.listInventory,
  });

  Json toJson() {
    return {
      'Visita': visitId,
      'ListInventario': listInventory.map((item) => item.toJson()).toList(),
    };
  }

  final int visitId;
  final List<Inventory> listInventory;
}
