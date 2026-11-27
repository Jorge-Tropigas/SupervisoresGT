// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

class RetrieveScheduledVisitsUserRequest {
  RetrieveScheduledVisitsUserRequest({required this.user, required this.date});

  Json toJson() {
    return {'usuario': user, 'fecha': date};
  }

  final String user;
  final String date;
}
