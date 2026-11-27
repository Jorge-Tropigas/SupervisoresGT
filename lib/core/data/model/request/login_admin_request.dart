// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

class LoginAdminRequest {
  LoginAdminRequest({required this.user, required this.password});

  Json toJson() {
    return {'usuario': user, 'password': password};
  }

  final String user;
  final String password;
}
