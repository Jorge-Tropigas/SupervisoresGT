// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

class GetCylinderSalePointSaleRequest {
  GetCylinderSalePointSaleRequest({required this.salePoint});

  Json toJson() {
    return {'puntoVenta': salePoint};
  }

  final String salePoint;
}
