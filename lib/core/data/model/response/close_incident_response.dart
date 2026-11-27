// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class CloseIncidentResponse {
  CloseIncidentResponse({
    required this.status,
    required this.message,
    required this.date,
  });

  factory CloseIncidentResponse.fromJson(Json json) {
    return CloseIncidentResponse(
      status: parse(json['Estado'], fallback: 0),
      message: parseNullable(json['Mensaje']),
      date: parseNullable(json['Fecha']),
    );
  }

  final int status;
  final String? message;
  final String? date;
}
