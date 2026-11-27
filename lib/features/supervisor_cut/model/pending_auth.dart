// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class PendingAuth {
  PendingAuth({
    required this.authId,
    required this.cutId,
    required this.salePoint,
    required this.supervisor,
    required this.storeUser,
    required this.visit,
  });

  factory PendingAuth.fromJson(Json json) {
    return PendingAuth(
      authId: parse<int>(json['AUTORIZACION_CORTE_ID'], fallback: 0),
      cutId: parse<int>(json['NO_CORTE'], fallback: 0),
      salePoint: parse<String>(json['PUNTO_VENTA'], fallback: ''),
      supervisor: parse<String>(json['SUPERVISOR'], fallback: ''),
      storeUser: parse<String>(json['USUARIO_TIENDA'], fallback: ''),
      visit: parse<int>(json['VISITA'], fallback: 0),
    );
  }

  Json toJson() {
    return {
      'AUTORIZACION_CORTE_ID': authId,
      'NO_CORTE': cutId,
      'PUNTO_VENTA': salePoint,
      'SUPERVISOR': supervisor,
      'USUARIO_TIENDA': storeUser,
      'VISITA': visit,
    };
  }

  final int authId;
  final int cutId;
  final String salePoint;
  final String supervisor;
  final String storeUser;
  final int visit;
}
