// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/core/network/connectivity_handler.dart';
import 'package:tomza_kit/utils/network_check.dart';
import 'package:tomza_kit/utils/notifier.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/model/request/get_incident_types_visit_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/incident_open_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/valid_visit_status_request.dart';
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/global/global_bloc.dart';
import 'package:app_supervisores_gt/features/checklist/model/type_incident.dart';
import 'package:app_supervisores_gt/features/photo_descripcion/models/photo_arguments.dart';
import 'package:app_supervisores_gt/features/photo_descripcion/page/photo_description.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/model/arguments_by_visits.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/model/enum_visit_status.dart';

class ChecklistLogic extends ChangeNotifier {
  ChecklistLogic({
    required this._repository,
    required this.args,
    required this.global,
  }) {
    getTypeIncident();
  }

  final Repository _repository;
  final GlobalBloc global;
  final ArgumentsByVisits args;

  List<TypeIncident> _typeIncident = [];
  List<TypeIncident> get typeIncident => _typeIncident;

  List<ChecklistItem> _listItems = [];
  List<ChecklistItem> get listItems => _listItems;

  final List<bool> _completedFlags = <bool>[];
  final Map<String, bool> _itemHasIncident = {};
  final Map<String, int> _itemPhotoCounts = {};

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  final List<ChecklistItem> _defaultItems = <ChecklistItem>[
    ChecklistItem(
      icon: Icons.motorcycle_outlined,
      label: 'MOTO',
      incidentVisitId: 0,
    ),
    ChecklistItem(icon: Icons.car_repair, label: 'CARRO', incidentVisitId: 0),
    ChecklistItem(
      icon: Icons.store_rounded,
      label: 'FACHADA',
      incidentVisitId: 0,
    ),
    ChecklistItem(
      icon: Icons.lock_rounded,
      label: 'CANDADOS',
      incidentVisitId: 0,
    ),
    ChecklistItem(
      icon: Icons.fire_extinguisher_rounded,
      label: 'EXTINTOR',
      incidentVisitId: 0,
    ),
    ChecklistItem(
      icon: Icons.lightbulb_outline_rounded,
      label: 'LUZ Y AGUA',
      incidentVisitId: 0,
    ),
    ChecklistItem(
      icon: Icons.badge_outlined,
      label: 'LICENCIAS',
      incidentVisitId: 0,
    ),
    ChecklistItem(
      icon: Icons.remove_shopping_cart_outlined,
      label: 'FALTA DE PRODUCTO',
      incidentVisitId: 0,
    ),
    ChecklistItem(
      icon: Icons.build_circle_sharp,
      label: 'MANTENIMIENTO',
      incidentVisitId: 0,
    ),
  ];

  Future<void> getTypeIncident() async {
    setLoading(true);

    if (!await NetworkUtils.hasInternet()) {
      showError('No tienes conexión a internet');
      setLoading(false);
      return;
    }

    if (!await ConnectivityHandler.hasExcellentSignal()) {
      showError(
        'Señal débil o inestable. Para anular una factura debe tener una señal excelente',
      );
      setLoading(false);
      return;
    }

    try {
      final request = GetIncidentTypesVisitRequest(visitHeader: args.visitId);
      final result = await _repository.incidentTypesByVisit(request);
      setLoading(false);

      _typeIncident = result.typeIncident;
      _itemHasIncident.clear();
      _itemPhotoCounts.clear();
      _listItems = _typeIncident.map((it) {
        final match = _defaultItems.firstWhere(
          (element) =>
              element.label.trim().toUpperCase() ==
              it.description.trim().toUpperCase(),
          orElse: () => ChecklistItem(
            icon: Icons.help_outline,
            label: it.description,
            incidentVisitId: it.incident ?? 0,
          ),
        );

        final label = match.label;
        _itemHasIncident[label] = it.incident != null;
        _itemPhotoCounts[label] = it.photo;

        return ChecklistItem(
          icon: match.icon,
          label: label,
          incidentVisitId: it.incident ?? 0,
        );
      }).toList();
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> validVisitStatus(
    BuildContext context,
    int visitId,
    String title,
    ChecklistItem incident,
    int typeIncident,
  ) async {
    // Capturar referencia del Navigator antes de setLoading y awaits
    final NavigatorState? nav = Navigator.maybeOf(context);

    setLoading(true);

    if (!await NetworkUtils.hasInternet()) {
      showError('No tienes conexión a internet');
      setLoading(false);
      return;
    }

    if (!await ConnectivityHandler.hasExcellentSignal()) {
      showError(
        'Señal débil o inestable. Para anular una factura debe tener una señal excelente',
      );
      setLoading(false);
      return;
    }

    try {
      final request = ValidVisitStatusRequest(visitId: visitId);
      final result = await _repository.validVisitStatus(request);
      setLoading(false);

      if (result.status != 1) {
        if (result.status == 0) {
          incidentOpen(visitId, title, incident, typeIncident, context);
        } else {
          showError(result.message ?? 'Error al validar la visita');
          return;
        }
      } else {
        if (nav == null || !nav.mounted) return;

        await nav.push(
          MaterialPageRoute(
            builder: (context) => PhotoDescriptionPage(
              title: title,
              args: PhotoArguments(
                visitId: visitId,
                incidentId: incident.incidentVisitId,
                typeIncident: typeIncident,
              ),
            ),
          ),
        );
        await getTypeIncident();
      }
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> incidentOpen(
    int visitId,
    String title,
    ChecklistItem incident,
    int typeIncident,
    BuildContext context,
  ) async {
    final NavigatorState? nav = Navigator.maybeOf(context);
    setLoading(true);

    if (!await NetworkUtils.hasInternet()) {
      showError('No tienes conexión a internet');
      setLoading(false);
      return;
    }

    if (!await ConnectivityHandler.hasExcellentSignal()) {
      showError(
        'Señal débil o inestable. Para anular una factura debe tener una señal excelente',
      );
      setLoading(false);
      return;
    }

    try {
      final request = IncidentOpenRequest(
        incidentId: incident.incidentVisitId,
        visitId: visitId,
        typeIncident: typeIncident,
        observation: '',
        latitude: global.currentPosition?.longitude.toString() ?? '14.5410878',
        longitude:
            global.currentPosition?.longitude.toString() ?? '-90.5579503',
        user: global.currentUser.user,
      );
      final result = await _repository.incidentOpen(request);
      setLoading(false);

      if (result.status == 1) {
        if (nav == null || !nav.mounted) return;

        await nav.push(
          MaterialPageRoute(
            builder: (context) => PhotoDescriptionPage(
              title: title,
              args: PhotoArguments(
                visitId: visitId,
                incidentId: incident.incidentVisitId,
                typeIncident: typeIncident,
              ),
            ),
          ),
        );
        await getTypeIncident();
      } else {
        showError(result.message ?? 'Error al abrir el incidente');
        return;
      }
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Color statusColor(EnumVisitStatus s, ThemeData theme) {
    return switch (s) {
      EnumVisitStatus.pending => theme.disabledColor,
      EnumVisitStatus.inProgress => Colors.amber,
      EnumVisitStatus.complete => Colors.green,
      EnumVisitStatus.created => Colors.white,
      EnumVisitStatus.closed => Colors.red,
    };
  }

  String statusLabel(EnumVisitStatus s) {
    return switch (s) {
      EnumVisitStatus.pending => 'Pendiente',
      EnumVisitStatus.inProgress => 'En proceso',
      EnumVisitStatus.complete => 'Completo',
      EnumVisitStatus.created => 'Creado',
      EnumVisitStatus.closed => 'Cerrado',
    };
  }

  bool isCompletedItem(String label) {
    final int idx = _listItems.indexWhere(
      (ChecklistItem it) => it.label == label,
    );
    return idx >= 0 && idx < _completedFlags.length && _completedFlags[idx];
  }

  int getItemPhotoCount(String label) {
    return _itemPhotoCounts[label] ?? 0;
  }

  bool hasIncident(String label) => _itemHasIncident[label] ?? false;

  EnumVisitStatus statusFor(String label) {
    if (!hasIncident(label)) return EnumVisitStatus.created;
    if (getItemPhotoCount(label) > 0) return EnumVisitStatus.complete;
    return EnumVisitStatus.pending;
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}

class ChecklistItem {
  ChecklistItem({
    required this.icon,
    required this.label,
    required this.incidentVisitId,
  });

  final IconData icon;
  final String label;
  final int incidentVisitId;

  static ChecklistItem get mock => ChecklistItem(
    icon: Icons.check,
    label: 'Item de prueba',
    incidentVisitId: 0,
  );
}
