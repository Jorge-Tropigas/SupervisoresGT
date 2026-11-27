// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class ScheduleVisits {
  ScheduleVisits({
    required this.description,
    required this.statusDescription,
    required this.status,
    required this.dateVisit,
    required this.pointSale,
    required this.visit,
  });

  factory ScheduleVisits.fromJson(Json json) {
    return ScheduleVisits(
      description: parse(json['DESCRIPCION'], fallback: ''),
      statusDescription: parse(json['DESCRIPCION_ESTADO'], fallback: ''),
      status: parse(json['ESTADO'], fallback: 0),
      dateVisit: parse(json['FECHA_VISITA'], fallback: ''),
      pointSale: parse(json['PUNTO_VENTA'], fallback: ''),
      visit: parse(json['VISITA'], fallback: 0),
    );
  }

  Json toJson() {
    return {
      'DESCRIPCION': description,
      'DESCRIPCION_ESTADO': statusDescription,
      'ESTADO': status,
      'FECHA_VISITA': dateVisit,
      'PUNTO_VENTA': pointSale,
      'VISITA': visit,
    };
  }

  final String description;
  final String statusDescription;
  final int status;
  final String dateVisit;
  final String pointSale;
  final int visit;
}
