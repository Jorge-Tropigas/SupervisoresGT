// Package imports:
import 'package:material_ui/material_ui.dart';

enum EnumVisitStatus {
  created,
  pending,
  inProgress,
  complete,
  closed;

  static EnumVisitStatus fromDescription(String description) {
    switch (description.toUpperCase()) {
      case 'CREADO':
        return EnumVisitStatus.created;
      case 'EN PROCESO':
        return EnumVisitStatus.inProgress;
      case 'CERRADO':
        return EnumVisitStatus.closed;
      case 'PENDIENTE':
        return EnumVisitStatus.pending;
      case 'COMPLETADO':
        return EnumVisitStatus.complete;
      default:
        return EnumVisitStatus.created;
    }
  }
}

extension EnumVisitStatusExt on EnumVisitStatus {
  String get name {
    switch (this) {
      case EnumVisitStatus.created:
        return 'Creado';
      case EnumVisitStatus.inProgress:
        return 'En Progreso';
      case EnumVisitStatus.closed:
        return 'Cerrado';
      case EnumVisitStatus.pending:
        return 'Pendiente';
      case EnumVisitStatus.complete:
        return 'Completo';
    }
  }

  Color get color {
    switch (this) {
      case EnumVisitStatus.created:
        return Colors.grey;
      case EnumVisitStatus.inProgress:
        return Colors.orange;
      case EnumVisitStatus.closed:
        return Colors.red;
      case EnumVisitStatus.pending:
        return Colors.grey;
      case EnumVisitStatus.complete:
        return Colors.green;
    }
  }

  int get index {
    switch (this) {
      case EnumVisitStatus.created:
        return 1;
      case EnumVisitStatus.inProgress:
        return 2;
      case EnumVisitStatus.closed:
        return 3;
      case EnumVisitStatus.pending:
        return 4;
      case EnumVisitStatus.complete:
        return 5;
    }
  }

  Color get colorText {
    switch (this) {
      case EnumVisitStatus.created:
        return Colors.white;
      case EnumVisitStatus.inProgress:
        return Colors.white;
      case EnumVisitStatus.closed:
        return Colors.white;
      case EnumVisitStatus.pending:
        return Colors.white;
      case EnumVisitStatus.complete:
        return Colors.white;
    }
  }
}
