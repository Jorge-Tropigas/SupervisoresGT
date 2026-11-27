// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class ProductDifference {
  ProductDifference({
    required this.product,
    required this.description,
    required this.emptyCylinders,
    required this.quantity,
  });

  factory ProductDifference.fromJson(Json json) {
    return ProductDifference(
      product: parse(json['PRODUCTO'], fallback: 0),
      description: parse(json['DESCRIPCION'], fallback: ''),
      emptyCylinders: parse(json['CIL_VACIOS'], fallback: 0),
      quantity: parse(json['CANTIDAD'], fallback: 0),
    );
  }

  Json toJson() {
    return {
      'PRODUCTO': product,
      'DESCRIPCION': description,
      'CIL_VACIOS': emptyCylinders,
      'CANTIDAD': quantity,
    };
  }

  final int product;
  final String description;
  final int emptyCylinders;
  final int quantity;
}
