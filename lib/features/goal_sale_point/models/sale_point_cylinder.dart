// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

class SalePointCylinder {
  SalePointCylinder({
    required this.product,
    required this.presentation,
    required this.description,
    required this.quantity,
  });

  factory SalePointCylinder.fromJson(Json json) {
    return SalePointCylinder(
      product: json['PRODUCTO'] as int? ?? 0,
      presentation: json['PRESENTACION'] as int? ?? 0,
      description: json['DESCRIPCION'] as String? ?? '',
      quantity: json['CANTIDAD'] as int? ?? 0,
    );
  }

  final int product;
  final int presentation;
  final String description;
  final int quantity;

  Json toJson() {
    return {
      'PRODUCTO': product,
      'PRESENTACION': presentation,
      'DESCRIPCION': description,
      'CANTIDAD': quantity,
    };
  }
}
