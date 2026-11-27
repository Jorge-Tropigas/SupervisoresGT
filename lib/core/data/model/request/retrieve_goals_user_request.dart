// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

class RetrieveGoalsByUserRequest {
  RetrieveGoalsByUserRequest({required this.user});

  Json toJson() {
    return {'usuario': user};
  }

  final String user;
}
