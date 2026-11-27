// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

class GetCylinderSalesUserRequest {
  GetCylinderSalesUserRequest({required this.user});

  Json toJson() {
    return {'usuario': user};
  }

  final String user;
}
