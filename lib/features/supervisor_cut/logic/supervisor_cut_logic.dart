// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/core/location/gps_service.dart';
import 'package:tomza_kit/core/network/connectivity_handler.dart';
import 'package:tomza_kit/features/printing/printer_bloc.dart';
import 'package:tomza_kit/features/printing/printer_page.dart';
import 'package:tomza_kit/ui/components/input/tomza_user_input.dart';
import 'package:tomza_kit/ui/components/tomza_button.dart';
import 'package:tomza_kit/ui/themes/colors.dart';
import 'package:tomza_kit/utils/network_check.dart';
import 'package:tomza_kit/utils/notifier.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/model/request/accept_reject_cut_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/change_auth_status_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/get_inventory_differences_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/get_supervisors_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/list_pending_auth_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/request_auth_cut_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/retrieve_pending_cuts_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/token_generate_request.dart';
import 'package:app_supervisores_gt/core/data/model/response/get_supervisors_response.dart';
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/global/global_bloc.dart';
import 'package:app_supervisores_gt/core/routes/route_paths.dart';
import 'package:app_supervisores_gt/features/supervisor_cut/model/pending_auth.dart';
import 'package:app_supervisores_gt/features/supervisor_cut/model/pending_cuts.dart';
import 'package:app_supervisores_gt/features/supervisor_cut/model/product_difference.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';

class SupervisorCutLogic extends ChangeNotifier {
  SupervisorCutLogic({
    required this._repository,
    required this.context,
    required this.global,
  }) {
    loadCuts(searchType);
  }

  final Repository _repository;
  final BuildContext context;
  final GlobalBloc global;
  AppLocationService get _gps => sl.get<AppLocationService>();

  final TextEditingController bagController = TextEditingController();
  final TextEditingController plateController = TextEditingController();

  String searchType = 'P';
  VoidCallback? onNavigateToAuthorizationTab;

  List<PendingCuts> supervisorCuts = [];
  List<PendingAuth> pendingAuth = [];

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> loadCuts(String type) async {
    searchType = type;

    if (searchType == 'P') {
      await getSupervisorCuts();
    } else if (searchType == 'AP') {
      await getPendingAuth();
    } else {
      await getSupervisorCuts();
    }
  }

  Future<void> getSupervisorCuts() async {
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
      final request = RetrievePendingCutsRequest(user: global.currentUser.user);
      final result = await _repository.retrievePendingCuts(request);
      setLoading(false);

      supervisorCuts = result.pendingCuts;
    } catch (e) {
      setLoading(false);
      supervisorCuts = [];
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> acceptRejectCut(
    PendingCuts cut,
    PendingAuth? authCut,
    int type,
  ) async {
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

    if (global.currentPosition == null) {
      final status = await _gps.checkAndRequestPermission();
      if (status == GpsStatus.serviceDisabled) {
        showError(
          'El servicio de ubicación está deshabilitado. Por favor active el GPS',
        );
        setLoading(false);
        return;
      }

      if (status == GpsStatus.permissionDenied) {
        showError(
          'Permiso de ubicación denegado. Por favor otorgue los permisos',
        );
        setLoading(false);
        return;
      }

      if (status == GpsStatus.permissionDeniedForever) {
        showError(
          'Permiso de ubicación denegado permanentemente. Por favor habilítelo en configuración',
        );
        setLoading(false);
        return;
      }

      showInfo('Obteniendo ubicación...');

      final position = await _gps.getCurrentPositionDetail();

      global.currentPosition = position;
      notifyListeners();
    }

    if (global.currentPosition == null) {
      setLoading(false);
      showError(
        'Ubicación no disponible: No se pudo obtener tu ubicación actual. Activa el GPS y vuelve a intentar.',
      );
      return;
    }

    setLoading(false);
    showDialogConfirmCut(cut, authCut, type);
  }

  void showCreateToken(BuildContext context) {
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Creacion de Token',
          style: GoogleFonts.gabarito(fontSize: 18, fontWeight: .bold),
        ),
        content: Text('¿Esta seguro de generar un token?'),
        actions: [
          TomzaTextButton(
            label: 'Cancelar',
            textColor: TropigasGTColors.error,
            fontSize: 12,
            onPressed: () => Navigator.pop(context),
          ),
          TomzaPrimaryButton(
            label: 'Aceptar',
            color: TropigasGTColors.focusedEditTxt,
            fontSize: 12,
            fontWeight: .bold,
            textColor: TropigasGTColors.layout,
            onPressed: () => generateToken(),
          ),
        ],
      ),
    );
  }

  Future<void> generateToken() async {
    Navigator.pop(context);
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
      showInfo('Generando el token...');
      final request = TokenGenerateRequest(user: global.currentUser.user);
      final result = await _repository.tokenGenerate(request);
      setLoading(false);

      if (result.status == 0) {
        showError(result.message ?? 'Error al generar el token');
        return;
      } else {
        // Navigator.pop(context);
        showSuccess(result.message ?? 'Token generado correctamente');
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(
              'Token creado:',
              style: GoogleFonts.gabarito(fontSize: 16, fontWeight: .bold),
            ),
            content: Text(
              result.token.toString(),
              style: GoogleFonts.gabarito(fontSize: 32, fontWeight: .normal),
              textAlign: .center,
            ),
            actions: [
              TomzaPrimaryButton(
                label: 'Aceptar',
                fontSize: 12,
                fontWeight: .bold,
                textColor: TropigasGTColors.layout,
                color: TropigasGTColors.focusedEditTxt,
                onPressed: () {
                  Navigator.pop(context);
                  getSupervisorCuts();
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void showDialogConfirmCut(PendingCuts? cut, PendingAuth? authCut, int type) {
    final title = type == 1 ? 'Aceptar corte' : 'Rechazar corte';
    final description = type == 1
        ? '¿Está seguro de aceptar el corte?'
        : '¿Está seguro de rechazar el corte?';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          title,
          style: GoogleFonts.gabarito(fontSize: 18, fontWeight: .bold),
        ),
        content: Text(description),
        actions: [
          TomzaTextButton(
            label: 'Cancelar',
            textColor: TropigasGTColors.error,
            fontSize: 12,
            onPressed: () => Navigator.pop(ctx),
          ),
          TomzaPrimaryButton(
            label: 'Aceptar',
            color: TropigasGTColors.focusedEditTxt,
            fontSize: 12,
            fontWeight: .bold,
            textColor: TropigasGTColors.layout,
            onPressed: () {
              Navigator.pop(ctx);
              if (type == 1) {
                showDialogBagIdentifier(cut, authCut, type);
              } else {
                _executeAcceptRejectCut(cut, authCut, type, '', '');
              }
            },
          ),
        ],
      ),
    );
  }

  void showDialogBagIdentifier(
    PendingCuts? cut,
    PendingAuth? authCut,
    int type,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Identificador de Bolsas',
          style: GoogleFonts.gabarito(fontSize: 18, fontWeight: .bold),
        ),
        content: Column(
          mainAxisSize: .min,
          children: [
            UserInput(
              title: 'Identificador de Bolsa',
              controller: bagController,
            ),
            UserInput(title: 'Placa', controller: plateController),
          ],
        ),
        actions: [
          TomzaTextButton(
            label: 'Cancelar',
            textColor: TropigasGTColors.error,
            fontSize: 12,
            onPressed: () {
              clearControllers();
              Navigator.pop(ctx);
            },
          ),
          TomzaPrimaryButton(
            label: 'Aceptar',
            color: TropigasGTColors.focusedEditTxt,
            fontSize: 12,
            fontWeight: .bold,
            textColor: TropigasGTColors.layout,
            onPressed: () {
              Navigator.pop(ctx);
              _executeAcceptRejectCut(
                cut,
                authCut,
                type,
                bagController.text,
                plateController.text,
              );
              clearControllers();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _executeAcceptRejectCut(
    PendingCuts? cut,
    PendingAuth? authCut,
    int type,
    String bagIdentifier,
    String plate,
  ) async {
    if (cut == null && authCut == null) {
      showError('No se encontró el corte');
      return;
    }

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
      final request = AcceptRejectCutRequest(
        tokenId: cut?.supervisorToken ?? 0,
        encDelivery: cut?.deliveryId ?? 0,
        type: type,
        latitude: global.currentPosition?.latitude.toString() ?? '0',
        longitude: global.currentPosition?.longitude.toString() ?? '0',
        user: global.currentUser.user,
        bagIdentifier: bagIdentifier,
        plate: plate,
      );
      final result = await _repository.acceptRejectCut(request);
      setLoading(false);

      _handleCutResponse(result.status, result, cut);
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _handleCutResponse(int status, dynamic result, PendingCuts? cut) {
    switch (status) {
      case 1:
        navigateToPrint(context, result.document, null);
        getSupervisorCuts();
        break;
      case 2:
        showSuccess('Corte rechazado correctamente');
        getSupervisorCuts();
        break;
      case -14:
        showError('Autorización pendiente, no se puede procesar el corte');
        break;
      case -13:
        getSupervisorCuts();
        if (result.productDifferences != null) {
          _showDifferencesDialog(
            result.productDifferences!,
            canRequestAuth: true,
            cut: cut,
          );
        }
        break;
      case -12:
        showError('No se pudo obtener la ubicación actual');
        break;
      case -11:
        showError('El punto de venta no tiene ubicación registrada');
        break;
      case -10:
        if (result.productDifferences != null) {
          _showDifferencesDialog(
            result.productDifferences!,
            canRequestAuth: true,
            cut: cut,
          );
        }
        break;
      case -9:
        getSupervisorCuts();
        showError('No se encontró inventario del día');
        break;
      case -8:
        getSupervisorCuts();
        showError('No se encontró inventario del punto de venta');
        break;
      case -7:
        getSupervisorCuts();
        showError('No se encontró la visita');
        break;
      case -6:
        showError('La placa no tiene un usuario asignado');
        break;
      case -5:
        showError('La placa no fue encontrada');
        break;
      case -4:
        showError('El identificador de bolsa no está disponible');
        break;
      case -3:
        showError('El identificador de bolsa no está asignado');
        break;
      case -2:
        showError('El identificador de bolsa no existe');
        break;
      case -1:
        showError(result.message ?? 'Error al procesar el corte');
        break;
      default:
        showError(result.message ?? 'Error desconocido');
    }
  }

  void _showDifferencesDialog(
    List<ProductDifference> differences, {
    bool canRequestAuth = false,
    PendingCuts? cut,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Diferencias de Inventario',
          style: GoogleFonts.gabarito(fontSize: 18, fontWeight: .bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: differences.length,
            itemBuilder: (context, index) {
              final diff = differences[index];
              return ListTile(
                dense: true,
                title: Text(
                  diff.description,
                  style: GoogleFonts.gabarito(fontSize: 14, fontWeight: .bold),
                ),
                subtitle: Text(
                  'Producto: ${diff.product} | Cilindros Vacíos: ${diff.emptyCylinders} | Cantidad: ${diff.quantity}',
                  style: GoogleFonts.gabarito(fontSize: 12),
                ),
              );
            },
          ),
        ),
        actions: [
          if (canRequestAuth && cut != null)
            TomzaPrimaryButton(
              label: 'Solicitar Autorización',
              color: TropigasGTColors.focusedEditTxt,
              fontSize: 12,
              fontWeight: .bold,
              textColor: TropigasGTColors.layout,
              onPressed: () {
                Navigator.pop(ctx);
                _requestAuthCut(cut);
              },
            ),
          TomzaTextButton(
            label: 'Cerrar',
            textColor: TropigasGTColors.error,
            fontSize: 12,
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  Future<void> _requestAuthCut(PendingCuts cut) async {
    setLoading(true);
    try {
      final request = RequestAuthCutRequest(
        deliveryId: cut.deliveryId,
        supervisor: global.currentUser.user,
      );
      final result = await _repository.requestAuthCut(request);
      setLoading(false);

      if (result.status == 1) {
        showSuccess(result.message ?? 'Solicitud de autorización enviada');
        getSupervisorCuts();
      } else {
        showError(result.message ?? 'Error al solicitar autorización');
      }
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // ================================================================
  // Authorization tab methods
  // ================================================================

  List<SupervisorUser> supervisorsList = [];
  String? selectedSupervisorUser;
  final TextEditingController reasonController = TextEditingController();

  Future<void> getSupervisors() async {
    try {
      final request = GetSupervisorsRequest(plant: 1);
      final result = await _repository.getSupervisors(request);
      supervisorsList = result.supervisors;
    } catch (e) {
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void showSupervisorFilterDialog() async {
    if (supervisorsList.isEmpty) {
      setLoading(true);
      await getSupervisors();
      setLoading(false);
    }

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Seleccionar Supervisor',
          style: GoogleFonts.gabarito(fontSize: 18, fontWeight: .bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: supervisorsList.length,
            itemBuilder: (context, index) {
              final supervisor = supervisorsList[index];
              return ListTile(
                title: Text(
                  supervisor.fullName,
                  style: GoogleFonts.gabarito(fontSize: 14),
                ),
                subtitle: Text(
                  supervisor.user,
                  style: GoogleFonts.gabarito(
                    fontSize: 12,
                    color: TropigasGTColors.textSecondary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  selectedSupervisorUser = supervisor.user;
                  getPendingAuthBySupervisor(supervisor.user);
                },
              );
            },
          ),
        ),
        actions: [
          TomzaTextButton(
            label: 'Cancelar',
            textColor: TropigasGTColors.error,
            fontSize: 12,
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  Future<void> getPendingAuthBySupervisor(String supervisorUser) async {
    setLoading(true);

    if (!await NetworkUtils.hasInternet()) {
      showError('No tienes conexión a internet');
      setLoading(false);
      return;
    }

    try {
      final request = ListPendingAuthRequest(user: supervisorUser);
      final result = await _repository.listPendingAuth(request);
      setLoading(false);

      pendingAuth = result.listPendingAuth;
    } catch (e) {
      setLoading(false);
      pendingAuth = [];
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void showAcceptAuthDialog(PendingAuth auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Aceptar Autorización',
          style: GoogleFonts.gabarito(fontSize: 18, fontWeight: .bold),
        ),
        content: Column(
          mainAxisSize: .min,
          children: [
            Text('¿Está seguro de aceptar esta autorización?'),
            SizedBox(height: 12),
            UserInput(title: 'Motivo', controller: reasonController),
          ],
        ),
        actions: [
          TomzaTextButton(
            label: 'Cancelar',
            textColor: TropigasGTColors.error,
            fontSize: 12,
            onPressed: () {
              reasonController.clear();
              Navigator.pop(ctx);
            },
          ),
          TomzaPrimaryButton(
            label: 'Aceptar',
            color: TropigasGTColors.focusedEditTxt,
            fontSize: 12,
            fontWeight: .bold,
            textColor: TropigasGTColors.layout,
            onPressed: () {
              Navigator.pop(ctx);
              _changeAuthStatus(auth, 2, reasonController.text);
              reasonController.clear();
            },
          ),
        ],
      ),
    );
  }

  void showRejectAuthDialog(PendingAuth auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Rechazar Autorización',
          style: GoogleFonts.gabarito(fontSize: 18, fontWeight: .bold),
        ),
        content: Text('¿Está seguro de rechazar esta autorización?'),
        actions: [
          TomzaTextButton(
            label: 'Cancelar',
            textColor: TropigasGTColors.error,
            fontSize: 12,
            onPressed: () => Navigator.pop(ctx),
          ),
          TomzaPrimaryButton(
            label: 'Rechazar',
            color: TropigasGTColors.error,
            fontSize: 12,
            fontWeight: .bold,
            textColor: TropigasGTColors.layout,
            onPressed: () {
              Navigator.pop(ctx);
              _changeAuthStatus(auth, 3, '');
            },
          ),
        ],
      ),
    );
  }

  Future<void> _changeAuthStatus(
    PendingAuth auth,
    int status,
    String reason,
  ) async {
    setLoading(true);

    if (!await NetworkUtils.hasInternet()) {
      showError('No tienes conexión a internet');
      setLoading(false);
      return;
    }

    try {
      final request = ChangeAuthStatusRequest(
        user: global.currentUser.user,
        authCutId: auth.authId,
        status: status,
        reason: reason,
      );
      final result = await _repository.changeAuthStatus(request);
      setLoading(false);

      if (result.status == 1) {
        showSuccess('Estado de autorización actualizado');
        getPendingAuthBySupervisor(
          selectedSupervisorUser ?? global.currentUser.user,
        );
      } else {
        showError(result.message ?? 'Error al cambiar el estado');
      }
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> viewDifferences(PendingAuth auth) async {
    setLoading(true);

    if (!await NetworkUtils.hasInternet()) {
      showError('No tienes conexión a internet');
      setLoading(false);
      return;
    }

    try {
      final request = GetInventoryDifferencesRequest(
        visit: auth.visit,
        salePoint: auth.salePoint,
        cutNumber: auth.cutId,
        user: auth.storeUser,
      );
      final result = await _repository.getInventoryDifferences(request);
      setLoading(false);

      if (result.status == 1 && result.differences != null) {
        _showDifferencesDialog(result.differences!);
      } else {
        showError(result.message ?? 'Error al obtener diferencias');
      }
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> getPendingAuth() async {
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
      final request = ListPendingAuthRequest(user: global.currentUser.user);
      final result = await _repository.listPendingAuth(request);
      setLoading(false);

      if (result.listPendingAuth.isEmpty) {
        showError('No se encontraron solicitudes pendientes de autorización');
      } else {
        pendingAuth = result.listPendingAuth;
      }
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> navigateToPrint(
    BuildContext context,
    String? document,
    List<String>? documents,
  ) async {
    final Uint8List? doc = global.decodeBase64Pdf(document ?? '');
    final List<Uint8List?> docs = global.decodeBase64Pdfs(documents);
    if ((doc == null || doc.isEmpty) && (docs.isEmpty)) {
      showInfo('No hay documentos disponibles para imprimir');
      return;
    }

    List<PrinterDocument> pdfs = [];
    if (doc != null && doc.isNotEmpty) {
      pdfs.add(PrinterDocument(name: 'Factura', bytes: doc));
    }

    if (docs.isNotEmpty) {
      for (var i = 0; i < docs.length; i++) {
        final bytes = docs[i];
        if (bytes != null) {
          pdfs.add(PrinterDocument(name: 'Voucher ${i + 1}', bytes: bytes));
        }
      }
    }

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrinterPage(
            printerArgs: PrinterArguments(
              paperWidthInches: 3,
              documents: pdfs,
              // documentBytes: doc,
              onTap: () =>
                  Navigator.popAndPushNamed(context, RoutePaths.presale),
              onSuccessPrint: () async {
                /* if (global.currentUser.cutId == 0 &&
                    global.currentUser.shiftId == 0) {
                  _logout(context);
                } else { */
                Navigator.popAndPushNamed(context, RoutePaths.presale);
                // }
              },
            ),
          ),
        ),
      );
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearControllers() {
    bagController.clear();
    plateController.clear();
  }

  @override
  void dispose() {
    bagController.dispose();
    plateController.dispose();
    reasonController.dispose();
    super.dispose();
  }
}
