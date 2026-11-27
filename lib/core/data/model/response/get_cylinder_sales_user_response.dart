// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

// Project imports:
import 'package:app_supervisores_gt/features/dashboard/model/cylinder_sales.dart';

class GetCylinderSalesUserResponse {
  GetCylinderSalesUserResponse({
    required this.status,
    required this.cylinders,
    this.message,
  });

  factory GetCylinderSalesUserResponse.fromJson(Json json) {
    return GetCylinderSalesUserResponse(
      status: parse(json['Estado'], fallback: 0),
      cylinders:
          (json['Cilindros'] as List<dynamic>?)
              ?.map((e) => CylinderSales.fromJson(e as Json))
              .toList() ??
          [],
      message: parse(json['Mensaje'], fallback: ''),
    );
  }

  final int status;
  final String? message;
  final List<CylinderSales> cylinders;
}
