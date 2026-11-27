// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

class RequestAuthCutRequest {
  RequestAuthCutRequest({required this.deliveryId, required this.supervisor});

  Json toJson() {
    return {'EntregaEnc': deliveryId, 'Supervisor': supervisor};
  }

  final int deliveryId;
  final String supervisor;
}
