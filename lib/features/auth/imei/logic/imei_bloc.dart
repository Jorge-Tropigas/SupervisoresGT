// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/ui/themes/colors.dart';
import 'package:tomza_kit/utils/notifier.dart';

// Project imports:
import 'package:app_supervisores_gt/core/app/app_version.dart';
import 'package:app_supervisores_gt/core/data/model/request/valid_imei_request.dart';
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/routes/route_paths.dart';
import 'package:app_supervisores_gt/core/storage/shared_preferences_helper.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';

class ImeiLogic extends ChangeNotifier {
  ImeiLogic({required this.context, required this._repository});

  final BuildContext context;
  final Repository _repository;

  // Controllers for IMEI form
  final TextEditingController imeiController = TextEditingController();
  // Form keys
  final GlobalKey<FormState> imeiFormKey = GlobalKey<FormState>();

  bool _isImeiValid = false;
  bool get isImeiValid => _isImeiValid;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _version = '';
  String get version => _version;

  Future<String> loadVersion() async {
    return _version = await AppVersion.displayVersion();
  }

  Future<void> validateIMEI() async {
    setLoading(true);

    final helper = sl<SharedPreferencesHelper>();

    /* if (!await ConnectivityHandler.hasExcellentSignal()) {
      showError(
        'Señal débil o inestable. Para ingresar debe tener una señal excelente',
      );
      setLoading(false);
      return;
    } */

    if (!imeiFormKey.currentState!.validate()) {
      return;
    }

    if (imeiController.text.isEmpty) {
      validateIMEIInput(imeiController.text.trim());
      return;
    }

    final request = ValidImeiRequest(imei: imeiController.text.trim());
    debugPrint('[ImeiBloc][REQUEST] ${request.toJson()}');

    try {
      final r = await _repository.validImei(request);
      setLoading(false);

      // Cualquier respuesta 200 implica IMEI válido, sin importar si el
      // servicio envía o no un mensaje. Ignoramos r.isRegistered para evitar
      // depender de ese campo.
      final imei = imeiController.text.trim();
      await helper.saveManualImei(imei);
      await helper.setImeiValidatedOnce(true);
      await helper.saveLastValidatedImei(imei);

      if (r.message.isNotEmpty) {
        showInfo(r.message);
      }

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, RoutePaths.loginUser);
      }
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
      if (context.mounted) {
        await Navigator.pushReplacementNamed(context, RoutePaths.loginAdmin);
      }
    }
  }

  void showImeiHelpDialog() {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: TropigasGTColors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  decoration: const BoxDecoration(
                    color: TropigasGTColors.secondary,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.help_outline_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'AYUDA IMEI',
                        style: GoogleFonts.gabarito(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      _buildHelpItem(
                        Icons.dialpad_rounded,
                        'Marque *#06# en su teléfono',
                      ),
                      const SizedBox(height: 16),
                      _buildHelpItem(
                        Icons.settings_rounded,
                        'Configuración > Acerca del teléfono',
                      ),
                      const SizedBox(height: 16),
                      _buildHelpItem(
                        Icons.battery_std_rounded,
                        'Busque en la etiqueta de la batería',
                      ),
                      const SizedBox(height: 16),
                      _buildHelpItem(
                        Icons.inventory_2_rounded,
                        'Revise la caja original del dispositivo',
                      ),
                    ],
                  ),
                ),
                // Footer
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TropigasGTColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'ENTENDIDO',
                        style: GoogleFonts.gabarito(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildHelpItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: TropigasGTColors.secondary),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.gabarito(
              fontSize: 15,
              color: TropigasGTColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // Form validation
  String? validateIMEIInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      _isImeiValid = false;
      return 'El IMEI es requerido';
    }
    if (value.trim().length != 15) {
      _isImeiValid = false;
      return 'El IMEI debe tener exactamente 15 dígitos';
    }
    if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
      _isImeiValid = false;
      return 'El IMEI debe contener solo números';
    }

    _isImeiValid = true;
    return null;
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
