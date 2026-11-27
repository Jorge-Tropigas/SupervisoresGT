// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

class CreatePhotoIncidentRequest {
  CreatePhotoIncidentRequest({
    required this.idIncident,
    required this.index,
    required this.photo,
  });

  Json toJson() {
    return {'Incidencia': idIncident, 'Indice': index, 'Fotografia': photo};
  }

  final int idIncident;
  final int index;
  final String photo;
}
