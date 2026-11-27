// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

// Project imports:
import 'package:app_supervisores_gt/features/stores/model/store.dart';

class RetrieveStoresAssignedResponse {
  RetrieveStoresAssignedResponse({required this.result, required this.stores});

  factory RetrieveStoresAssignedResponse.fromJson(Json json) {
    return RetrieveStoresAssignedResponse(
      result: parse(json['resultados'], fallback: 0),
      stores: json['tiendas'] != null
          ? (json['tiendas'] as List).map((e) => Store.fromJson(e)).toList()
          : [],
    );
  }

  Json toJson() {
    return {
      'resultados': result,
      'tiendas': stores.map((e) => e.toJson()).toList(),
    };
  }

  final int result;
  final List<Store> stores;
}
