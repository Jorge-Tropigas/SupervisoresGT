// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class PendingCuts {
  PendingCuts({
    required this.description,
    required this.deliveryId,
    required this.date,
    required this.deliveryPDV,
    required this.supervisorToken,
    required this.cutTotal,
    required this.cutAuthStatus,
    required this.cutAuthStatusDescription,
  });

  factory PendingCuts.fromJson(Json json) {
    return PendingCuts(
      description: parse(json['DESCRIPCION'], fallback: ''),
      deliveryId: parse(json['ENTREGA_ENC_ID'], fallback: 0),
      date: parse(json['FECHA'], fallback: ''),
      deliveryPDV: parse(json['PDV_ENTREGA'], fallback: ''),
      supervisorToken: parse(json['TOKEN_SUPERVISOR_ID'], fallback: 0),
      cutTotal: parse(json['TOTAL_CORTE'], fallback: 0),
      cutAuthStatus: parse(json['ESTADO_AUT_CORTE'], fallback: 0),
      cutAuthStatusDescription: parse(
        json['DESCRIPCION_ESTADO_AUT_CORTE'],
        fallback: '',
      ),
    );
  }

  Json toJson() {
    return {
      'DESCRIPCION': description,
      'ENTREGA_ENC_ID': deliveryId,
      'FECHA': date,
      'PDV_ENTREGA': deliveryPDV,
      'TOKEN_SUPERVISOR_ID': supervisorToken,
      'TOTAL_CORTE': cutTotal,
      'ESTADO_AUT_CORTE': cutAuthStatus,
      'DESCRIPCION_ESTADO_AUT_CORTE': cutAuthStatusDescription,
    };
  }

  final String description;
  final int deliveryId;
  final String date;
  final String deliveryPDV;
  final int supervisorToken;
  final double cutTotal;
  final int cutAuthStatus;
  final String cutAuthStatusDescription;
}
