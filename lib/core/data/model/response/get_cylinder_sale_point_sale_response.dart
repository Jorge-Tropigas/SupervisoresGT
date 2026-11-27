// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

// Project imports:
import 'package:app_supervisores_gt/features/goal_sale_point/models/sale_point_cylinder.dart';

class GetCylinderSalePointSaleResponse {
  GetCylinderSalePointSaleResponse({
    required this.status,
    this.message,
    required this.cylinders,
  });

  factory GetCylinderSalePointSaleResponse.fromJson(Json json) {
    return GetCylinderSalePointSaleResponse(
      status: parse(json['Estado'], fallback: 0),
      message: parseNullable(json['Mensaje']),
      cylinders: json['Cilindros'] is List<dynamic>
          ? (json['Cilindros'] as List<dynamic>)
                .map((x) => SalePointCylinder.fromJson(x as Json))
                .toList()
          : [],
    );
  }

  final int status;
  final String? message;
  final List<SalePointCylinder> cylinders;
}
