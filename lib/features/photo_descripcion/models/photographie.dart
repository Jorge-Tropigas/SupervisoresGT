// Dart imports:
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// Package imports:
import 'package:tomza_kit/core/network/api_client.dart';
import 'package:tomza_kit/utils/json_parser.dart';

class Photographie {
  Photographie({
    required this.photo,
    required this.idIncidentPhoto,
    required this.index,
  });

  factory Photographie.fromJson(Json json) {
    return Photographie(
      photo: parse(json['FOTOGRAFIA'], fallback: ''),
      idIncidentPhoto: parse(json['INCIDENCIA_FOTOGRAFIA_ID'], fallback: 0),
      index: parse(json['INDICE'], fallback: 0),
    );
  }

  factory Photographie.fromFile(File file, {required int index}) {
    final bytes = file.readAsBytesSync();
    return Photographie(
      photo: base64Encode(bytes),
      idIncidentPhoto: 0,
      index: index,
    );
  }

  Json toJson() {
    return {
      'FOTOGRAFIA': photo,
      'INCIDENCIA_FOTOGRAFIA_ID': idIncidentPhoto,
      'INDICE': index,
    };
  }

  Uint8List get decodedBytes => base64Decode(photo);

  final String photo;
  final int idIncidentPhoto;
  final int index;
}
