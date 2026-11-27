// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class Incident {
  Incident({required this.idIncident, required this.observation});

  factory Incident.fromJson(Json json) {
    return Incident(
      idIncident: parse(json['INCIDENCIA'], fallback: 0),
      observation: parse(json['OBSERVACIONES'], fallback: ''),
    );
  }

  Json toJson() {
    return {'INCIDENCIA': idIncident, 'OBSERVACIONES': observation};
  }

  final int idIncident;
  final String observation;
}
