// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

// Project imports:
import 'package:app_supervisores_gt/features/supervisor_cut/model/product_difference.dart';

class AcceptRejectCutResponse {
  AcceptRejectCutResponse({
    required this.document,
    required this.status,
    this.message,
    required this.productDifferences,
  });

  factory AcceptRejectCutResponse.fromJson(Json json) {
    return AcceptRejectCutResponse(
      document: parse(json['DatosImpresion'], fallback: ''),
      status: parse(json['Estado'], fallback: 0),
      message: parseNullable(json['Mensaje']),
      productDifferences: json['Diferencias'] != null
          ? (json['Diferencias'] as List)
                .map((e) => ProductDifference.fromJson(e))
                .toList()
          : null,
    );
  }

  final String document;
  final int status;
  final String? message;
  final List<ProductDifference>? productDifferences;
}
