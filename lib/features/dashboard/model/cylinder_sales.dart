// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class CylinderSales {
  CylinderSales({
    required this.quantity,
    required this.description,
    required this.presentation,
    required this.product,
  });

  factory CylinderSales.fromJson(Json json) {
    return CylinderSales(
      quantity: parse(json['CANTIDAD'], fallback: 0),
      description: parse(json['DESCRIPCION'], fallback: ''),
      presentation: parse(json['PRESENTACION'], fallback: 0),
      product: parse(json['PRODUCTO'], fallback: 0),
    );
  }

  Json toJson() {
    return {
      'CANTIDAD': quantity,
      'DESCRIPCION': description,
      'PRESENTACION': presentation,
      'PRODUCTO': product,
    };
  }

  final double quantity;
  final String description;
  final int presentation;
  final int product;
}
