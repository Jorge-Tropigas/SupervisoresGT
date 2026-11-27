// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

class GetInventoryRequest {
  GetInventoryRequest({required this.idVisit, required this.salePoint});

  Json toJson() {
    return {'visita': idVisit, 'puntoVenta': salePoint};
  }

  final int idVisit;
  final String salePoint;
}
