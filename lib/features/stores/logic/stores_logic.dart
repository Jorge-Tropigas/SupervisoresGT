// Flutter imports:

// Package imports:
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/core/network/connectivity_handler.dart';
import 'package:tomza_kit/utils/network_check.dart';
import 'package:tomza_kit/utils/notifier.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/model/request/retrieve_scheduled_visits_user_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/retrieve_stores_assigned_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/visit_request.dart';
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/global/global_bloc.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/model/schedule_visits.dart';
import 'package:app_supervisores_gt/features/stores/model/enum_visit_created.dart';
import 'package:app_supervisores_gt/features/stores/model/store.dart';

class StoresLogic extends ChangeNotifier {
  StoresLogic({
    required this.context,
    required this._repository,
    required this.global,
  }) {
    getStores();
  }

  final BuildContext context;
  final Repository _repository;
  final GlobalBloc global;

  List<Store> stores = [];
  List<ScheduleVisits> _scheduledVisits = [];

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> getStores() async {
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
      await getScheduledVisits();
      final request = RetrieveStoresAssignedRequest(
        user: global.currentUser.user,
        pageNumber: 1,
      );
      final result = await _repository.retrieveStoresAssignes(request);
      setLoading(false);

      stores = result.stores;
      for (var store in stores) {
        if (_scheduledVisits.any(
          (element) => element.pointSale == store.pointSale,
        )) {
          store.visitStatus = EnumVisitCreated.created;
        }
      }
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> createVisit(Store store) async {
    // if (store.visitStatus.name == EnumVisitCreated.created.name) {
    //   showError('Ya se ha creado la visita');
    //   return;
    // } else {
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

    final salePoint = store.pointSale;

    try {
      final request = VisitRequest(
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        salePoint: salePoint,
        user: global.currentUser.user,
      );
      final result = await _repository.createVisit(request);
      setLoading(false);

      showSuccess(result.message ?? 'Visita creada correctamente');
      store.visitStatus = EnumVisitCreated.created;
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> getScheduledVisits() async {
    setLoading(true);

    if (!await NetworkUtils.hasInternet()) {
      showError('No tienes conexión a internet');
      setLoading(false);
      return;
    }

    if (!await ConnectivityHandler.hasExcellentSignal()) {
      showError(
        'Señal débil o inestable. Para ver las facturas debe tener una señal excelente',
      );
      setLoading(false);
      return;
    }

    try {
      final request = RetrieveScheduledVisitsUserRequest(
        user: global.currentUser.user,
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
      final result = await _repository.retrieveScheduledVisits(request);
      setLoading(false);

      _scheduledVisits = result.scheduleVisits;
    } catch (e) {
      setLoading(false);
      _scheduledVisits = [];
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
