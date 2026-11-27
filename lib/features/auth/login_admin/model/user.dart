// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class User {
  User({
    required this.user,
    required this.name,
    required this.lastName,
    required this.employee,
    required this.employeeType,
    required this.plant,
    required this.plantName,
  });

  factory User.fromJson(Json json) {
    return User(
      user: parse(json['USUARIO'], fallback: ''),
      name: parse(json['NOMBRES'], fallback: ''),
      lastName: parse(json['APELLIDOS'], fallback: ''),
      employee: parse(json['EMPLEADO'], fallback: ''),
      employeeType: parse(json['TIPO_EMPLEADO'], fallback: 0),
      plant: parse(json['PLANTA'], fallback: 0),
      plantName: parse(json['NOMBRE_PLANTA'], fallback: ''),
    );
  }

  Json toJson() {
    return {
      'USUARIO': user,
      'NOMBRES': name,
      'APELLIDOS': lastName,
      'EMPLEADO': employee,
      'TIPO_EMPLEADO': employeeType,
      'PLANTA': plant,
      'NOMBRE_PLANTA': plantName,
    };
  }

  final String user;
  final String name;
  final String lastName;
  final String employee;
  final int employeeType;
  final int plant;
  final String plantName;

  String get fullName => '$name $lastName'.trim();
}
