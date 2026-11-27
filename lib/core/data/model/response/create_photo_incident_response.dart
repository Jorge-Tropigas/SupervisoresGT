// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class CreatePhotoIncidentResponse {
  CreatePhotoIncidentResponse({
    required this.status,
    required this.message,
    required this.date,
  });

  factory CreatePhotoIncidentResponse.fromJson(Json json) {
    return CreatePhotoIncidentResponse(
      status: parse(json['Estado'], fallback: 0),
      message: parseNullable(json['Mensaje']),
      date: parseNullable(json['Fecha']),
    );
  }

  final int status;
  final String? message;
  final String? date;
}
