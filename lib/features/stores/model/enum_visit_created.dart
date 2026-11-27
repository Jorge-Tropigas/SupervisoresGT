// Package imports:
import 'package:material_ui/material_ui.dart';

enum EnumVisitCreated { created, nonCreated }

extension EnumVisitCreatedExt on EnumVisitCreated {
  String get name {
    switch (this) {
      case EnumVisitCreated.created:
        return 'Visita Activa';
      case EnumVisitCreated.nonCreated:
        return 'Visita Inactiva';
    }
  }

  static EnumVisitCreated fromDescription(String description) {
    switch (description.toUpperCase()) {
      case 'VISITA ACTIVA':
        return EnumVisitCreated.created;
      case 'VISITA INACTIVA':
        return EnumVisitCreated.nonCreated;
      default:
        return EnumVisitCreated.nonCreated;
    }
  }

  Color get color {
    switch (this) {
      case EnumVisitCreated.created:
        return Colors.green;
      case EnumVisitCreated.nonCreated:
        return Colors.red;
    }
  }
}
