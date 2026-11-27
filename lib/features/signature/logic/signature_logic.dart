// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:tomza_kit/core/network/connectivity_handler.dart';
import 'package:tomza_kit/utils/network_check.dart';
import 'package:tomza_kit/utils/notifier.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/model/request/close_incident_request.dart';
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/global/global_bloc.dart';
import 'package:app_supervisores_gt/core/routes/route_paths.dart';
import 'package:app_supervisores_gt/features/signature/models/signature_args.dart';

class SignatureLogic extends ChangeNotifier {
  SignatureLogic({
    required this.global,
    required this._repository,
    required this.args,
  });

  final Repository _repository;
  final GlobalBloc global;
  final SignatureArgs args;

  DateTime dateApp = DateTime.now();

  final GlobalKey<SfSignaturePadState> signatureKey =
      GlobalKey<SfSignaturePadState>();

  bool _hasSigned = false;
  bool get hasSigned => _hasSigned;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  void onDrawStart() {
    if (!_hasSigned) {
      _hasSigned = true;
      notifyListeners();
    }
  }

  void clear() {
    signatureKey.currentState?.clear();
    _hasSigned = false;
    notifyListeners();
  }

  Future<void> getDate() async {
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
      final result = await _repository.getDate();
      setLoading(false);

      final dateTime = DateTime.tryParse(result.date ?? '${DateTime.now()}');

      dateApp = dateTime ?? DateTime.now();
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
      return;
    }
  }

  Future<void> saveSignature(BuildContext context) async {
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
      final signatureImage = await CloseIncidentRequest.captureSignature(
        signatureKey,
      );

      if (signatureImage == null) {
        showError('Error al capturar la firma');
        setLoading(false);
        return;
      }

      final signatureBase64 = CloseIncidentRequest.imageToBase64(
        signatureImage,
      );

      final request = CloseIncidentRequest(
        idVisit: args.visitId,
        latitude: global.currentPosition?.latitude.toString() ?? '14.5410878',
        longitude:
            global.currentPosition?.longitude.toString() ?? '-90.5579503',
        user: global.currentUser.user,
        signature: signatureBase64,
      );
      final result = await _repository.closeIncident(request);
      setLoading(false);

      Navigator.pushReplacementNamed(context, RoutePaths.programmedVisits);
      showSuccess(result.message ?? 'Visita cerrada exitosamente');
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
      return;
    }
  }

  /* Future<ui.Image?> save() async {
    setLoading(true);
    if (!_hasSigned) return null;

    if (!await NetworkUtils.hasInternet()) {
      showError('No tienes conexión a internet');
      setLoading(false);
      return null;
    }

    if (!await ConnectivityHandler.hasExcellentSignal()) {
      showError(
        'Señal débil o inestable. Para ver las facturas debe tener una señal excelente',
      );
      setLoading(false);
      return null;
    }

    final signatureImage = await CloseIncidentRequest.captureSignature(
      signatureKey,
    );

    if (signatureImage == null) {
      showError('Error al capturar la firma');
      setLoading(false);
      return null;
    }

    final signatureBase64 = CloseIncidentRequest.imageToBase64(signatureImage);

    try {
      final request = CloseIncidentRequest(
        idVisit: args.visitId,
        latitude: global.currentPosition?.latitude.toString() ?? '14.5410878',
        longitude:
            global.currentPosition?.longitude.toString() ?? '-90.5579503',
        user: 'RIXQUIAC',
        signature: signatureBase64,
      );
      final result = await _repository.closeIncident(request);
      setLoading(false);

      return signatureKey.currentState?.toImage();
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
      return null;
    }
  } */

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
