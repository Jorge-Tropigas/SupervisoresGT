// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

// Project imports:
import 'package:app_supervisores_gt/features/photo_descripcion/models/photographie.dart';

class IncidentOpenRequest {
  IncidentOpenRequest({
    required this.incidentId,
    required this.visitId,
    required this.typeIncident,
    required this.observation,
    required this.latitude,
    required this.longitude,
    required this.user,
    this.photos,
  });

  Json toJson() {
    return {
      'Incidencia': incidentId,
      'Visita': visitId,
      'TipoIncidencia': typeIncident,
      'Observaciones': observation,
      'Latitud': latitude,
      'Longitud': longitude,
      'Usuario': user,
      'Fotografias': photos,
    };
  }

  final int incidentId;
  final int visitId;
  final int typeIncident;
  final String observation;
  final String latitude;
  final String longitude;
  final String user;
  final List<Photographie>? photos;
}
