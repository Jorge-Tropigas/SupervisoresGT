// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

class ValidVisitStatusRequest {
  ValidVisitStatusRequest({required this.visitId});

  Json toJson() {
    return {'visitaId': visitId};
  }

  final int visitId;
}
