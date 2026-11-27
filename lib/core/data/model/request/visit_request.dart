// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

class VisitRequest {
  VisitRequest({
    required this.user,
    required this.salePoint,
    required this.date,
  });

  Json toJson() {
    return {
      'visitaRequest': jsonEncode({
        'FechaVisita': date,
        'PuntoVenta': salePoint,
        'Supervisor': user,
      }),
    };
  }

  final String user;
  final String salePoint;
  final String date;
}
