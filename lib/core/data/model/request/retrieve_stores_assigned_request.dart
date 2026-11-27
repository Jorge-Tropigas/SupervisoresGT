// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

class RetrieveStoresAssignedRequest {
  RetrieveStoresAssignedRequest({required this.user, required this.pageNumber});

  Json toJson() {
    return {'usuario': user, 'pageNumber': pageNumber};
  }

  final String user;
  final int pageNumber;
}
