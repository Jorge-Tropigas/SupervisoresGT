// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

// Project imports:
import 'package:app_supervisores_gt/features/stores/model/enum_visit_created.dart';

class Store {
  Store({
    required this.pointSale,
    required this.description,
    required this.phone,
    required this.employeeId,
    required this.employeeName,
    this.visitStatus = EnumVisitCreated.nonCreated,
  });

  factory Store.fromJson(Json json) {
    return Store(
      pointSale: parse(json['PUNTO_VENTA'], fallback: ''),
      description: parse(json['DESCRIPCION'], fallback: ''),
      phone: parseNullable(json['TELEFONO']),
      employeeId: parseNullable(json['EMPLEADO']),
      employeeName: parseNullable(json['NOMBRE_EMPLEADO']),
    );
  }

  Json toJson() {
    return {
      'PUNTO_VENTA': pointSale,
      'DESCRIPCION': description,
      'TELEFONO': phone,
      'EMPLEADO': employeeId,
      'NOMBRE_EMPLEADO': employeeName,
    };
  }

  final String pointSale;
  final String description;
  final String? phone;
  final String? employeeId;
  final String? employeeName;
  EnumVisitCreated visitStatus;
}
