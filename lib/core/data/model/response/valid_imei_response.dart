// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class ValidImeiResponse {
  ValidImeiResponse({
    required this.status,
    required this.message,
    required this.isRegister,
  });

  factory ValidImeiResponse.fromJson(Json json) {
    return ValidImeiResponse(
      status: parse(json['Estado'], fallback: 0),
      message: parse(json['Mensaje'], fallback: ''),
      isRegister: parse(json['Registrado'], fallback: false),
    );
  }

  final int status;
  final String message;
  final bool isRegister;
}
