// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class IncidentOpenResponse {
  IncidentOpenResponse({required this.status, this.message, this.date});

  factory IncidentOpenResponse.fromJson(Json json) {
    return IncidentOpenResponse(
      status: parse(json['Estado'], fallback: 0),
      message: parseNullable(json['Mensaje']),
      date: parseNullable(json['Fecha']),
    );
  }

  final int status;
  final String? message;
  final String? date;
}
