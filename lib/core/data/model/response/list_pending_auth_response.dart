// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

// Project imports:
import 'package:app_supervisores_gt/features/supervisor_cut/model/pending_auth.dart';

class ListPendingAuthResponse {
  ListPendingAuthResponse({required this.listPendingAuth});

  factory ListPendingAuthResponse.fromJson(Json json) {
    return ListPendingAuthResponse(
      listPendingAuth: json['data'] != null
          ? (json['data'] as List<dynamic>)
                .map((e) => PendingAuth.fromJson(e as Json))
                .toList()
          : [],
    );
  }

  final List<PendingAuth> listPendingAuth;
}
