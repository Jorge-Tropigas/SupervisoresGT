// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

// Project imports:
import 'package:app_supervisores_gt/features/photo_descripcion/models/incident.dart';
import 'package:app_supervisores_gt/features/photo_descripcion/models/photographie.dart';

class GetIncidentResponse {
  GetIncidentResponse({required this.photographies, required this.incident});

  factory GetIncidentResponse.fromJson(Json json) {
    return GetIncidentResponse(
      photographies: json['Fotografias'] != null
          ? (json['Fotografias'] as List)
                .map((x) => Photographie.fromJson(x))
                .toList()
          : [],
      incident: json['Incidencia'] != null
          ? Incident.fromJson(json['Incidencia'])
          : Incident(idIncident: 0, observation: ''),
    );
  }

  final List<Photographie> photographies;
  final Incident incident;
}
