// Dart imports:
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:tomza_kit/core/network/api_client.dart';

class CloseIncidentRequest {
  CloseIncidentRequest({
    required this.idVisit,
    required this.latitude,
    required this.longitude,
    required this.user,
    required this.signature,
  });

  Json toJson() {
    return {
      'Visita': idVisit,
      'Latitud': latitude,
      'Longitud': longitude,
      'Usuario': user,
      'Firma': signature,
    };
  }

  final int idVisit;
  final String latitude;
  final String longitude;
  final String user;
  final String signature;

  /// Converts Uint8List bytes to a base64 string.
  static String imageToBase64(Uint8List bytes) {
    return base64.encode(bytes);
  }

  static Future<Uint8List?> captureSignature(
    GlobalKey<SfSignaturePadState> key,
  ) async {
    try {
      final ui.Image? image = await key.currentState?.toImage();
      if (image == null) return null;

      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing signature: $e');
      return null;
    }
  }
}
