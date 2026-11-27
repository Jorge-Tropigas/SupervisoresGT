// Package imports:
import 'package:tomza_kit/utils/json_parser.dart';

class CreateUpdateIncidentResponse {
  CreateUpdateIncidentResponse({
    required this.status,
    required this.message,
    required this.date,
  });

  factory CreateUpdateIncidentResponse.fromJson(Map<String, dynamic> json) {
    return CreateUpdateIncidentResponse(
      status: parse(json['Estado'], fallback: 0),
      message: parseNullable(json['Mensaje']),
      date: parseNullable(json['Fecha']),
    );
  }

  final int status;
  final String? message;
  final String? date;
}
