// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

class GetIncidentRequest {
  GetIncidentRequest({required this.idIncident});

  Json toJson() {
    return {'incidenciaId': idIncident};
  }

  final int idIncident;
}
