// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class GetSupervisorsResponse {
  GetSupervisorsResponse({required this.supervisors});

  factory GetSupervisorsResponse.fromJson(Json json) {
    final list = json['ListUsuarios'] as List? ?? [];
    return GetSupervisorsResponse(
      supervisors: list.map((e) => SupervisorUser.fromJson(e as Json)).toList(),
    );
  }

  final List<SupervisorUser> supervisors;
}

class SupervisorUser {
  SupervisorUser({required this.user, required this.fullName});

  factory SupervisorUser.fromJson(Json json) {
    return SupervisorUser(
      user: parse(json['USUARIO'], fallback: ''),
      fullName: parse(json['NOMBRE_COMPLETO'], fallback: ''),
    );
  }

  final String user;
  final String fullName;
}
