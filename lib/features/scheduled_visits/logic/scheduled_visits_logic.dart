// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/tomza_kit.dart';
import 'package:tomza_kit/ui/components/tomza_search.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/model/request/retrieve_scheduled_visits_user_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/retrieve_stores_assigned_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/visit_request.dart';
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/global/global_bloc.dart';
import 'package:app_supervisores_gt/core/routes/route_paths.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/model/arguments_by_visits.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/model/date_filter.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/model/enum_visit_status.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/model/schedule_visits.dart';
import 'package:app_supervisores_gt/features/scheduled_visits/widgets/visit_action_modal.dart';
import 'package:app_supervisores_gt/features/stores/model/enum_visit_created.dart';
import 'package:app_supervisores_gt/features/stores/model/store.dart';

class ScheduledVisitsLogic extends ChangeNotifier {
  ScheduledVisitsLogic({required this._repository, required this.global}) {
    getScheduledVisits();
    getStores();
  }

  final Repository _repository;
  final GlobalBloc global;

  List<ScheduleVisits> _scheduledVisits = [];
  List<ScheduleVisits> get scheduledVisits => _scheduledVisits;
  List<Store> _stores = [];
  List<Store> get stores => _stores;

  TextEditingController salePointController = TextEditingController();

  DateTime? _selectedDate;
  DateTime? _customDate;
  DateTime? get customDate => _customDate;
  DateFilter _selectedFilter = DateFilter.today;
  DateFilter get selectedFilter => _selectedFilter;

  EnumVisitStatus visitStatus = EnumVisitStatus.created;

  bool _isFilterActive = true;
  bool get isFilterActive => _isFilterActive;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> getScheduledVisits() async {
    DateTime dateToUse;
    setLoading(true);
    switch (_selectedFilter) {
      case DateFilter.today:
        dateToUse = DateTime.now();
        break;
      case DateFilter.tomorrow:
        dateToUse = DateTime.now().add(const Duration(days: 1));
        break;
      case DateFilter.custom:
        if (_customDate != null) {
          dateToUse = _customDate!;
        } else {
          dateToUse = DateTime.now();
        }
        break;
      case DateFilter.none:
        dateToUse = DateTime.now();
        break;
    }

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
        date: DateFormat('yyyy-MM-dd').format(dateToUse),
      );
      final result = await _repository.retrieveScheduledVisits(request);
      setLoading(false);

      _scheduledVisits = result.scheduleVisits;

      visitStatus =
          _scheduledVisits.any((s) {
            final status = s.statusDescription.toLowerCase().trim();
            return status == EnumVisitStatus.created.name;
          })
          ? EnumVisitStatus.created
          : EnumVisitStatus.inProgress;
    } catch (e) {
      setLoading(false);
      _scheduledVisits = [];
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

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

      _stores = result.stores;
      for (var store in _stores) {
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

  Future<void> createVisit(String date, String salePoint) async {
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

    // final salePoint = store.pointSale;

    try {
      final request = VisitRequest(
        date: date,
        salePoint: salePoint,
        user: global.currentUser.user,
      );
      final result = await _repository.createVisit(request);
      setLoading(false);

      showSuccess(result.message ?? 'Visita creada correctamente');
      // store.visitStatus = EnumVisitCreated.created;
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void showAddVisitModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Column(
          crossAxisAlignment: .center,
          mainAxisSize: .min,
          children: [
            Row(
              mainAxisAlignment: .end,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            // SizedBox(height: 24),
            Text(
              'Crear Visita',
              textAlign: .center,
              style: GoogleFonts.gabarito(fontSize: 28, fontWeight: .w400),
            ),
            // SizedBox(height: 22),
            Text(
              'Seleccione un punto de venta',
              style: GoogleFonts.gabarito(fontSize: 16, fontWeight: .w400),
            ),
            SizedBox(height: 24),
            TomzaSearchField<Store>(
              items: _stores,
              itemToString: (store) => store.pointSale,
              onItemSelected: (store) =>
                  salePointController.text = store.pointSale,
              controller: salePointController,
            ),
            SizedBox(height: 16),
            DatePickerInput(
              label: 'Seleccione Fecha y hora programada',
              hintText: 'Seleccione una fecha',
              initialDate: _selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 30)),
              onDateChanged: setSelectedDate,
              enabled: true,
            ),
            SizedBox(height: 24),
            TomzaPrimaryButton(
              label: 'Crear Visita',
              color: TropigasGTColors.circleBackground,
              fontSize: 12,
              onPressed: () async {
                Navigator.pop(context);
                await createVisit(
                  DateFormat('yyyy-MM-dd').format(_selectedDate!),
                  salePointController.text,
                );
              },
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void showModalOptionsVisit(ScheduleVisits visit, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => VisitActionModal(
        visit: visit,
        onTapChecklist: () {
          Navigator.pop(context);
          navigateToChecklist(context, visit);
        },
        onTapGoals: () {
          Navigator.pop(context);
          navigateToGoals(context, visit);
        },
        onTapInventory: () {
          Navigator.pop(context);
          navigateToInventory(context, visit);
        },
      ),
    );
  }

  Future<void> navigateToChecklist(
    BuildContext context,
    ScheduleVisits visit,
  ) async {
    // Capturar referencia del Navigator antes de awaits
    final NavigatorState? nav = Navigator.maybeOf(context);

    // Sólo permitir navegar si la visita es hoy cuando el filtro está activo
    if (_isFilterActive) {
      final DateTime today = DateTime.now();
      final DateTime vd = DateTime.parse(visit.dateVisit);
      if (vd.year != today.year ||
          vd.month != today.month ||
          vd.day != today.day) {
        showError(
          'Para navegar al checklist, la visita debe estar programada para hoy.',
        );
        return;
      }
    }

    if (nav == null) return;

    nav
        .pushNamed(
          RoutePaths.checklist,
          arguments: ArgumentsByVisits(
            visitId: visit.visit,
            pointSale: visit.pointSale,
            pointSaleName: visit.description,
            status: visit.statusDescription,
          ),
        )
        .then((_) => getScheduledVisits());
  }

  Future<void> navigateToInventory(
    BuildContext context,
    ScheduleVisits visit,
  ) async {
    // Capturar referencia del Navigator antes de awaits
    final NavigatorState? nav = Navigator.maybeOf(context);

    // Sólo permitir navegar si la visita es hoy cuando el filtro está activo
    if (_isFilterActive) {
      final DateTime today = DateTime.now();
      final DateTime vd = DateTime.parse(visit.dateVisit);
      if (vd.year != today.year ||
          vd.month != today.month ||
          vd.day != today.day) {
        showError(
          'Para navegar al checklist, la visita debe estar programada para hoy.',
        );
        return;
      }
    }

    if (nav == null) return;

    nav
        .pushNamed(
          RoutePaths.inventory,
          arguments: ArgumentsByVisits(
            visitId: visit.visit,
            pointSale: visit.pointSale,
            pointSaleName: visit.description,
            status: visit.statusDescription,
          ),
        )
        .then((_) => getScheduledVisits());
  }

  Future<void> navigateToGoals(
    BuildContext context,
    ScheduleVisits visit,
  ) async {
    // Capturar referencia del Navigator antes de awaits
    final NavigatorState? nav = Navigator.maybeOf(context);

    // Sólo permitir navegar si la visita es hoy cuando el filtro está activo
    if (_isFilterActive) {
      final DateTime today = DateTime.now();
      final DateTime vd = DateTime.parse(visit.dateVisit);
      if (vd.year != today.year ||
          vd.month != today.month ||
          vd.day != today.day) {
        showError(
          'Para navegar al checklist, la visita debe estar programada para hoy.',
        );
        return;
      }
    }

    if (nav == null) return;

    nav
        .pushNamed(
          RoutePaths.goalsByPointSale,
          arguments: ArgumentsByVisits(
            visitId: visit.visit,
            pointSale: visit.pointSale,
            pointSaleName: visit.description,
            status: visit.statusDescription,
          ),
        )
        .then((_) => getScheduledVisits());
  }

  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setDateFilter(DateFilter filter) {
    _selectedFilter = filter;
    _isFilterActive = true;
    if (filter != DateFilter.custom) {
      _customDate = null;
    }
    getScheduledVisits();
  }

  void setCustomDate(DateTime date) {
    _customDate = date;
    _selectedFilter = DateFilter.custom;
    _isFilterActive = true;
    getScheduledVisits();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
