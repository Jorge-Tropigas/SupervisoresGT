class ArgumentsByVisits {
  ArgumentsByVisits({
    required this.visitId,
    required this.pointSale,
    this.pointSaleName,
    this.status,
    // this.latitude,
    // this.longitude,
  });

  final int visitId;
  final String pointSale;
  final String? pointSaleName;
  final String? status;
  // final double? latitude;
  // final double? longitude;
}
