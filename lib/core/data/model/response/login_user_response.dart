// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

// Project imports:
import 'package:app_supervisores_gt/features/auth/login_user/model/user.dart';

class LoginUserResponse {
  LoginUserResponse({required this.status, required this.user});

  factory LoginUserResponse.fromJson(Json json) {
    final usuarioData = json['Usuario'];
    return LoginUserResponse(
      status: parse(json['Estado'], fallback: 0),
      user: User.fromJson(Json.from(usuarioData)),
    );
  }

  Json toJson() {
    return {'Estado': status, 'Usuario': user.toJson()};
  }

  final int status;
  final User user;
}
