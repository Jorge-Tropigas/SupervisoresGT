class GetInventoryDifferencesRequest {
  GetInventoryDifferencesRequest({
    required this.visit,
    required this.salePoint,
    required this.cutNumber,
    required this.user,
  });

  final int visit;
  final String salePoint;
  final int cutNumber;
  final String user;
}
