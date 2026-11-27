// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

// Project imports:
import 'package:app_supervisores_gt/features/inventory/models/inventory.dart';

class GetInventoryResponse {
  GetInventoryResponse({
    required this.status,
    this.message,
    this.acceptCylinder,
    required this.listInventory,
  });

  factory GetInventoryResponse.fromJson(Json json) {
    return GetInventoryResponse(
      status: parse(json['Estado'], fallback: 0),
      message: parseNullable(json['Mensaje']),
      acceptCylinder: parseNullable(json['AceptaCilindros']),
      listInventory: json['Inventario'] != null
          ? (json['Inventario'] as List<dynamic>)
                .map((e) => Inventory.fromJson(e as Json))
                .toList()
          : [],
    );
  }

  final int status;
  final String? message;
  final String? acceptCylinder;
  final List<Inventory> listInventory;
}
