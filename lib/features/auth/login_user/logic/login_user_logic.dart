// Package imports:
import 'package:material_ui/material_ui.dart';
import 'package:tomza_kit/core/network/connectivity_handler.dart';
import 'package:tomza_kit/utils/network_check.dart';
import 'package:tomza_kit/utils/notifier.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/model/request/login_user_request.dart';
import 'package:app_supervisores_gt/core/data/model/response/login_user_response.dart';
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/global/global_bloc.dart';
import 'package:app_supervisores_gt/core/routes/route_paths.dart';
import 'package:app_supervisores_gt/core/storage/shared_preferences_helper.dart';
import 'package:app_supervisores_gt/utils/injection_container.dart';

class LoginUserLogic extends ChangeNotifier {
  LoginUserLogic({
    required this.context,
    required this._repository,
    required this._global,
  });

  final BuildContext context;
  final Repository _repository;
  final GlobalBloc _global;

  String version = '';

  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final int _shakeTick = 0;
  int get shakeTick => _shakeTick;

  final bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;
  bool _isLoginLoading = false;
  bool get isLoginLoading => _isLoginLoading;

  Future<void> login() async {
    setLoading(true);

    if (!await NetworkUtils.hasInternet()) {
      showError('Conectate a internet, o tienes muy poca señal a internet!');
      setLoading(false);
      return;
    }

    if (!await ConnectivityHandler.hasExcellentSignal()) {
      showError(
        'Señal débil o inestable. Para ingresar debe tener una señal excelente',
      );
      setLoading(false);
      return;
    }

    try {
      final request = LoginUserRequest(
        user: userController.text.toUpperCase().trim(),
        password: passwordController.text.toUpperCase().trim(),
      );
      final result = await _repository.login(request);
      setLoading(false);

      if (result.status == 1) {
        if (!context.mounted) return;

        await _startSession(result);

        // Navigator.pushReplacementNamed(context, RoutePaths.dashboard);
      } else {
        return;
      }
    } catch (e) {
      setLoading(false);
      showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _startSession(LoginUserResponse r) async {
    final SharedPreferencesHelper prefsHelper = sl<SharedPreferencesHelper>();
    final String? lastUser = await prefsHelper.getLastUser();

    if (lastUser == r.user.user) {
      await _global.saveSession(r);
      await prefsHelper.saveLastUser(r.user.user);
    }

    await _global.saveSession(r);
    if (context.mounted) {
      await Navigator.pushNamed(context, RoutePaths.dashboard);
    }
  }

  void setLoading(bool value) {
    _isLoginLoading = value;
    notifyListeners();
  }
}
