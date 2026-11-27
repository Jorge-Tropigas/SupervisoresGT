// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

class ValidImeiRequest {
  ValidImeiRequest({required this.imei});

  Json toJson() {
    return {'imei': imei};
  }

  final String imei;
}
