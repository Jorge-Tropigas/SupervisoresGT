// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class LoginAdminResponse {
  LoginAdminResponse({required this.status});

  factory LoginAdminResponse.fromJson(Json json) {
    return LoginAdminResponse(status: parse(json['Estado'], fallback: 0));
  }

  final int status;
}
