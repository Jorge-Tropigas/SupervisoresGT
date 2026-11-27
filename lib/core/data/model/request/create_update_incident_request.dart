// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

// Project imports:
import 'package:app_supervisores_gt/features/photo_descripcion/models/photographie.dart';

class CreateUpdateIncidentRequest {
  CreateUpdateIncidentRequest({
    required this.idIncident,
    required this.idVisit,
    required this.incidentType,
    required this.observation,
    required this.latitude,
    required this.longitude,
    required this.user,
    required this.photos,
  });

  Json toJson() {
    return {
      'Incidencia': idIncident,
      'Visita': idVisit,
      'TipoIncidencia': incidentType,
      'Observaciones': observation,
      'Latitud': latitude,
      'Longitud': longitude,
      'Usuario': user,
      'Fotografias': photos.map((photo) => photo.toJson()).toList(),
    };
  }

  final int idIncident;
  final int idVisit;
  final int incidentType;
  final String observation;
  final String latitude;
  final String longitude;
  final String user;
  final List<Photographie> photos;
}
