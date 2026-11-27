// Package imports:
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomza_kit/core/location/gps_service.dart';
import 'package:tomza_kit/core/network/env_config.dart';

// Project imports:
import 'package:app_supervisores_gt/core/data/datasource.dart';
import 'package:app_supervisores_gt/core/data/repository.dart';
import 'package:app_supervisores_gt/core/global/global_bloc.dart';
import 'package:app_supervisores_gt/core/service/env_service.dart';
import 'package:app_supervisores_gt/core/storage/shared_preferences_helper.dart';
import 'package:app_supervisores_gt/features/auth/login_user/model/user.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  await _initExternalDependencies();
  _initCoreServices();
  _initDataLayer();
  _initPresentationLayer();
}

Future<void> _initExternalDependencies() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (!sl.isRegistered<SharedPreferences>()) {
    sl.registerLazySingleton<SharedPreferences>(() => prefs);
  }
}

void _initCoreServices() {
  // EnvConfig / configuración base
  EnvConfig.initialize(baseUrl: EnvService.baseUrlNormalized);

  if (!sl.isRegistered<SharedPreferencesHelper>()) {
    sl.registerLazySingleton<SharedPreferencesHelper>(
      () => SharedPreferencesHelper(sl<SharedPreferences>()),
    );
  }

  if (!sl.isRegistered<AppLocationService>()) {
    sl.registerLazySingleton<AppLocationService>(() => AppLocationService());
  }

  if (!sl.isRegistered<User>()) {
    sl.registerLazySingleton<User>(_emptyUser);
  }

  // DataSource -> Repository
  if (!sl.isRegistered<Datasource>()) {
    sl.registerLazySingleton<Datasource>(() => DatasourceImpl());
  }

  if (!sl.isRegistered<RepositoryImpl>()) {
    sl.registerLazySingleton<RepositoryImpl>(
      () => RepositoryImpl(datasource: sl<Datasource>()),
    );
  }

  if (!sl.isRegistered<Repository>()) {
    sl.registerLazySingleton<Repository>(() => sl<RepositoryImpl>());
  }

  // GlobalBloc (singleton)
  if (!sl.isRegistered<GlobalBloc>()) {
    sl.registerLazySingleton<GlobalBloc>(
      () => GlobalBloc(user: sl<User>(), gps: sl<AppLocationService>()),
    );
  }
}

void _initDataLayer() {
  if (!sl.isRegistered<RepositoryImpl>()) {
    sl.registerLazySingleton<RepositoryImpl>(
      () => RepositoryImpl(datasource: sl<Datasource>()),
    );
  }

  if (!sl.isRegistered<Repository>()) {
    sl.registerLazySingleton<Repository>(() => sl<RepositoryImpl>());
  }
}

void _initPresentationLayer() {
  if (!sl.isRegistered<GlobalBloc>()) {
    sl.registerLazySingleton<GlobalBloc>(
      () => GlobalBloc(user: sl<User>(), gps: sl<AppLocationService>()),
    );
  }
}

User _emptyUser() => User(
  user: '',
  name: '',
  lastName: '',
  employee: '',
  employeeType: 0,
  plant: 0,
  plantName: '',
);
