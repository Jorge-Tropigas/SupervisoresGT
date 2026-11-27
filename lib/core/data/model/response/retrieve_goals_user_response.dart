// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class RetrieveGoalsByUserResponse {
  RetrieveGoalsByUserResponse({
    required this.status,
    required this.gallons,
    required this.goal,
    required this.projected,
    this.message,
  });

  factory RetrieveGoalsByUserResponse.fromJson(Json json) {
    return RetrieveGoalsByUserResponse(
      status: parse(json['Estado'], fallback: 0),
      gallons: parse(json['Galones'], fallback: 0),
      message: parseNullable(json['Mensaje']),
      goal: parse(json['Meta'], fallback: 0),
      projected: parse(json['Proyectado'], fallback: 0),
    );
  }

  Json toJson() {
    return {
      'Estado': status,
      'Galones': gallons,
      'Mensaje': message,
      'Meta': goal,
      'Proyectado': projected,
    };
  }

  final int status;
  final double gallons;
  final String? message;
  final double goal;
  final double projected;
}
