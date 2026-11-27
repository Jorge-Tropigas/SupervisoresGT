// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';

class AcceptRejectCutRequest {
  AcceptRejectCutRequest({
    required this.tokenId,
    required this.encDelivery,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.user,
    required this.bagIdentifier,
    required this.plate,
  });

  Json toJson() {
    return {
      'TokenID': tokenId,
      'EntregaEnc': encDelivery,
      'Tipo': type,
      'Latitud': latitude,
      'Longitud': longitude,
      'Usuario': user,
      'IdentificadorBolsa': bagIdentifier,
      'Placa': plate,
    };
  }

  final int tokenId;
  final int encDelivery;
  final int type;
  final String latitude;
  final String longitude;
  final String user;
  final String bagIdentifier;
  final String plate;
}
