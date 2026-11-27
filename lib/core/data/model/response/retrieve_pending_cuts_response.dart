// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

// Project imports:
import 'package:app_supervisores_gt/features/supervisor_cut/model/pending_cuts.dart';

class RetrievePendingCutsResponse {
  RetrievePendingCutsResponse({required this.pendingCuts});

  factory RetrievePendingCutsResponse.fromJson(Json json) {
    final raw = json['CortesPendientes'];
    final List<dynamic> list;
    if (raw is List<dynamic>) {
      list = raw;
    } else if (raw is Json) {
      list = [raw];
    } else {
      list = [];
    }
    return RetrievePendingCutsResponse(
      pendingCuts: list.map((e) => PendingCuts.fromJson(e as Json)).toList(),
    );
  }

  Json toJson() => {
    'CortesPendientes': pendingCuts.map((e) => e.toJson()).toList(),
  };

  final List<PendingCuts> pendingCuts;
}
