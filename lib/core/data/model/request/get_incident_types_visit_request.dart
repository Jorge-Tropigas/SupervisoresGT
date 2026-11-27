// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

class GetIncidentTypesVisitRequest {
  GetIncidentTypesVisitRequest({required this.visitHeader});

  Json toJson() {
    return {'visitaEncabezado': visitHeader};
  }

  final int visitHeader;
}
