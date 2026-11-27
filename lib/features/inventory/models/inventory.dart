// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class Inventory {
  Inventory({
    required this.missingCylinder,
    required this.fullCylinder,
    required this.emptyCylinder,
    required this.companyOwnedCylinder,
    required this.description,
    required this.assignedIPDV,
    required this.presentation,
    required this.product,
    required this.inventoryVisitId,
  });

  factory Inventory.fromJson(Json json) {
    return Inventory(
      missingCylinder: parseNullable(json['CIL_FALTANTES']),
      fullCylinder: parseNullable(json['CIL_LLENOS']),
      emptyCylinder: parseNullable(json['CIL_VACIOS']),
      companyOwnedCylinder: parseNullable(json['CIL_PROPIOS']),
      description: parse(json['DESCRIPCION'], fallback: ''),
      assignedIPDV: parse(json['IPDV_ASIGNADO'], fallback: 0),
      presentation: parse(json['PRESENTACION'], fallback: 0),
      product: parse(json['PRODUCTO'], fallback: 0),
      inventoryVisitId: parseNullable(json['VISITA_INVENTARIO_ID']),
    );
  }

  Json toJson() {
    return {
      'CIL_FALTANTES': missingCylinder,
      'CIL_LLENOS': fullCylinder,
      'CIL_VACIOS': emptyCylinder,
      'CIL_PROPIOS': companyOwnedCylinder,
      'DESCRIPCION': description,
      'IPDV_ASIGNADO': assignedIPDV,
      'PRESENTACION': presentation,
      'PRODUCTO': product,
      'VISITA_INVENTARIO_ID': inventoryVisitId,
    };
  }

  final int? missingCylinder;
  final int? fullCylinder;
  final int? emptyCylinder;
  final int? companyOwnedCylinder;
  final String description;
  final int assignedIPDV;
  final int presentation;
  final int product;
  final int? inventoryVisitId;
}
