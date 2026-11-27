// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

// Project imports:
import 'package:app_supervisores_gt/features/checklist/model/type_incident.dart';

class GetIncidentTypesVisitResponse {
  GetIncidentTypesVisitResponse({required this.typeIncident});

  factory GetIncidentTypesVisitResponse.fromJson(Json json) {
    return GetIncidentTypesVisitResponse(
      typeIncident: json['ListadoTipoIncidencias'] != null
          ? (json['ListadoTipoIncidencias'] as List)
                .map((it) => TypeIncident.fromJson(it))
                .toList()
          : [],
    );
  }

  final List<TypeIncident> typeIncident;
}
