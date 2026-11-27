// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class TypeIncident {
  TypeIncident({
    required this.incident,
    required this.typeIncident,
    required this.photo,
    required this.description,
  });

  factory TypeIncident.fromJson(Json json) {
    return TypeIncident(
      incident: json['INCIDENCIA'] != null
          ? parse(json['INCIDENCIA'], fallback: 0)
          : null,
      typeIncident: parse(json['TIPO_INCIDENCIA'], fallback: 0),
      photo: parse(json['FOTO'], fallback: 0),
      description: parse(json['DESCRIPCION'], fallback: ''),
    );
  }

  Json toJson() {
    return {
      'INCIDENCIA': incident,
      'TIPO_INCIDENCIA': typeIncident,
      'FOTO': photo,
      'DESCRIPCION': description,
    };
  }

  final int? incident;
  final int typeIncident;
  final int photo;
  final String description;
}
