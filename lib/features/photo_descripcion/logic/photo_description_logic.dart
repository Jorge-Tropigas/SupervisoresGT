// Dart imports:
import 'dart:io';

// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/core/network/connectivity_handler.dart';
import 'package:tomza_kit/utils/network_check.dart';
import 'package:tomza_kit/utils/notifier.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/model/request/create_update_incident_request.dart';
import 'package:app_supervisores_gt/core/data/model/request/get_incident_request.dart';
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/global/global_bloc.dart';
import 'package:app_supervisores_gt/features/photo_descripcion/models/photo_arguments.dart';
import 'package:app_supervisores_gt/features/photo_descripcion/models/photographie.dart';

class PhotoDescriptionLogic extends ChangeNotifier {
  PhotoDescriptionLogic({
    required this.args,
    required this._repository,
    required this._global,
  }) {
    _incidentId = args.incidentId;
    init();
  }

  final PhotoArguments args;
  final Repository _repository;
  final GlobalBloc _global;
  final ImagePicker _picker = ImagePicker();

  static const int maxPhotos = 4;
  final TextEditingController observationsController = TextEditingController();

  int _incidentId = 0;
  int get incidentId => _incidentId;

  List<Photographie> _photographies = [];
  List<Photographie> get photographies => _photographies;

  final List<File?> localImages = List.filled(maxPhotos, null);

  bool get hasExistingPhotos => _photographies.isNotEmpty;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Photographie? existingPhotoAtSlot(int slot) {
    final photoIndex = slot + 1;
    for (final p in _photographies) {
      if (p.index == photoIndex) return p;
    }
    return null;
  }

  List<int> get slotsWithPhotos {
    final slots = <int>[];
    for (int i = 0; i < maxPhotos; i++) {
      if (existingPhotoAtSlot(i) != null || localImages[i] != null) {
        slots.add(i);
      }
    }
    return slots;
  }

  Future<void> pickImage(int slotIndex) async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (picked != null) {
      localImages[slotIndex] = File(picked.path);
      notifyListeners();
    }
  }

  void removeImage(int slotIndex) {
    localImages[slotIndex] = null;
    notifyListeners();
  }

  List<Photographie> buildPhotoList() {
    final result = <Photographie>[];
    for (int i = 0; i < maxPhotos; i++) {
      final localFile = localImages[i];
      if (localFile != null) {
        result.add(Photographie.fromFile(localFile, index: i + 1));
      } else {
        final existing = existingPhotoAtSlot(i);
        if (existing != null) {
          result.add(existing);
        }
      }
    }
    return result;
  }

  Future<void> init() async {
    // if (args.incidentId != 0) {
    await getIncident();
    // } else {}
  }

  Future<void> getIncident() async {
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
      final request = GetIncidentRequest(idIncident: args.incidentId);
      final result = await _repository.getIncident(request);
      setLoading(false);

      _photographies = result.photographies;
      observationsController.text = result.incident.observation;
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void showSlotPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Selecciona la foto a reemplazar',
                style: GoogleFonts.gabarito(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...slotsWithPhotos.map(
              (index) => ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text('Foto ${index + 1}', style: GoogleFonts.gabarito()),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(index);
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> createUpdateIncident(BuildContext context) async {
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
      final request = CreateUpdateIncidentRequest(
        idIncident: args.incidentId,
        idVisit: args.visitId,
        incidentType: args.typeIncident,
        observation: observationsController.text,
        latitude: _global.currentPosition?.latitude.toString() ?? '14.5410878',
        longitude:
            _global.currentPosition?.longitude.toString() ?? '-90.5579503',
        user: _global.currentUser.user,
        photos: buildPhotoList(),
      );
      final result = await _repository.createUpdateIncident(request);
      setLoading(false);

      if (result.status != 1) {
        showError('Error al guardar la incidencia');
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
