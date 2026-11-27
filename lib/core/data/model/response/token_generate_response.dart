// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class TokenGenerateResponse {
  TokenGenerateResponse({required this.status, this.message, this.token});

  factory TokenGenerateResponse.fromJson(Json json) {
    return TokenGenerateResponse(
      status: parse(json['Estado'], fallback: 0),
      message: parse(json['Mensaje'], fallback: null),
      token: parse(json['Token'], fallback: null),
    );
  }

  Json toJson() {
    return {'Estado': status, 'Mensaje': message, 'Token': token};
  }

  final int status;
  final String? message;
  final String? token;
}
