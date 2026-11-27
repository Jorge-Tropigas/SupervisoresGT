// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

// Project imports:
import 'package:app_supervisores_gt/features/supervisor_cut/model/product_difference.dart';

class GetInventoryDifferencesResponse {
  GetInventoryDifferencesResponse({
    required this.status,
    this.message,
    this.differences,
  });

  factory GetInventoryDifferencesResponse.fromJson(Json json) {
    final list = json['Diferencias'] as List?;
    return GetInventoryDifferencesResponse(
      status: parse(json['Estado'], fallback: 0),
      message: parseNullable(json['Mensaje']),
      differences: list
          ?.map((e) => ProductDifference.fromJson(e as Json))
          .toList(),
    );
  }

  final int status;
  final String? message;
  final List<ProductDifference>? differences;
}
