// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class GetTargetSalePointResponse {
  GetTargetSalePointResponse({
    required this.status,
    required this.message,
    required this.gallons,
    required this.goal,
    required this.projected,
  });

  factory GetTargetSalePointResponse.fromJson(Json json) {
    return GetTargetSalePointResponse(
      status: parse(json['Estado'], fallback: 0),
      message: parseNullable(json['Mensaje']),
      gallons: parse(json['Galones'], fallback: 0.0),
      goal: parse(json['Meta'], fallback: 0.0),
      projected: parse(json['Proyectado'], fallback: 0.0),
    );
  }

  final int status;
  final String? message;
  final double gallons;
  final double goal;
  final double projected;
}
