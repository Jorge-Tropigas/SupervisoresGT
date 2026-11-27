// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class SearchSalePointResponse {
  SearchSalePointResponse({required this.salePoints});

  factory SearchSalePointResponse.fromJson(Json json) {
    final list = json['PuntosVenta'] as List? ?? [];
    return SearchSalePointResponse(
      salePoints: list.map((e) => SalePointItem.fromJson(e as Json)).toList(),
    );
  }

  final List<SalePointItem> salePoints;
}

class SalePointItem {
  SalePointItem({required this.description, required this.salePoint});

  factory SalePointItem.fromJson(Json json) {
    return SalePointItem(
      description: parse(json['DESCRIPCION'], fallback: ''),
      salePoint: parse(json['PUNTO_VENTA'], fallback: ''),
    );
  }

  final String description;
  final String salePoint;
}
