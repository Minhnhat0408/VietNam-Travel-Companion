import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vn_travel_companion/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:vn_travel_companion/core/network/connection_checker.dart';
import 'package:vn_travel_companion/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:vn_travel_companion/features/auth/data/repositories/auth_repository_implementation.dart';
import 'package:vn_travel_companion/features/auth/domain/repository/auth_repository.dart';
import 'package:vn_travel_companion/features/auth/domain/usecases/current_user.dart';
import 'package:vn_travel_companion/features/auth/domain/usecases/listen_auth_change.dart';
import 'package:vn_travel_companion/features/auth/domain/usecases/send_reset_password_email.dart';
import 'package:vn_travel_companion/features/auth/domain/usecases/update_password.dart';
import 'package:vn_travel_companion/features/auth/domain/usecases/user_login.dart';
import 'package:vn_travel_companion/features/auth/domain/usecases/user_logout.dart';
import 'package:vn_travel_companion/features/auth/domain/usecases/user_signup.dart';
import 'package:vn_travel_companion/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vn_travel_companion/features/user_preference/data/datasources/preferences_remote_datasource.dart';
import 'package:vn_travel_companion/features/user_preference/data/datasources/travel_type_remote_datasource.dart';
import 'package:vn_travel_companion/features/user_preference/data/repositories/preference_repository_implementation.dart';
import 'package:vn_travel_companion/features/user_preference/data/repositories/travel_type_repository_implementation.dart';
import 'package:vn_travel_companion/features/user_preference/domain/repositories/preference_repository.dart';
import 'package:vn_travel_companion/features/user_preference/domain/repositories/travel_type_repository.dart';
import 'package:vn_travel_companion/features/user_preference/presentation/bloc/preference/preference_bloc.dart';
import 'package:vn_travel_companion/features/user_preference/presentation/bloc/travel_types/travel_types_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initPreference();
  final supabase = await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogout(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => ListenToAuthChanges(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => SendResetPasswordEmail(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdatePassword(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        userLogout: serviceLocator(),
        appUserCubit: serviceLocator(),
        listenToAuthChanges: serviceLocator(),
        sendEmailReset: serviceLocator(),
        updatePassword: serviceLocator(),
      ),
    );
}

void _initPreference() {
  serviceLocator
    ..registerFactory<PreferencesRemoteDataSource>(
      () => PreferencesRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<PreferenceRepository>(
      () => PreferenceRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory<TravelTypeRemoteDatasource>(
      () => TravelTypeRemoteDatasourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<TravelTypeRepository>(
      () => TravelTypeRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => PreferencesBloc(
        preferenceRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => TravelTypesBloc(
        travelTypeRepository: serviceLocator(),
      ),
    );
}
