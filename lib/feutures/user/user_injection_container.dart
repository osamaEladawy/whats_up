


import 'package:whats_up/feutures/user/data/remote/data_sources/user_imp_remote_data_source.dart';
import 'package:whats_up/feutures/user/data/repositories/user_repository_imp.dart';

import '../../main_injection_container.dart';
import 'data/remote/data_sources/user_remote_data_sources.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/use_cases/credential/get_current_uid_usecasses.dart';
import 'domain/use_cases/credential/is_sign_in_usecases.dart';
import 'domain/use_cases/credential/sign_in_with_phone_number_usecases.dart';
import 'domain/use_cases/credential/sign_out_usecases.dart';
import 'domain/use_cases/credential/verify_phone_number_usecases.dart';
import 'domain/use_cases/user/create_user_usecases.dart';
import 'domain/use_cases/user/get_all_users_usecases.dart';
import 'domain/use_cases/user/get_device_number_usecases.dart';
import 'domain/use_cases/user/get_single_user_usecases.dart';
import 'domain/use_cases/user/update_user_usecases.dart';
import 'presentation/manager/auth/auth_cubit.dart';
import 'presentation/manager/cerdential/credential_cubit.dart';
import 'presentation/manager/get_device_number/get_device_number_cubit.dart';
import 'presentation/manager/get_single_user/get_single_user_cubit.dart';
import 'presentation/manager/user/user_cubit.dart';

Future<void> userInjectionContainer() async {

  // * CUBITS INJECTION

  sl.registerFactory<AuthCubit>(() => AuthCubit(
      getCurrentUidUseCases: sl.call(),
      isSignInUseCases: sl.call(),
      signOutUseCases: sl.call()
  ));

  sl.registerFactory<UserCubit>(() => UserCubit(
      getAllUsersUseCases: sl.call(),
      updateUserUseCases: sl.call()
  ));

  sl.registerFactory<GetSingleUserCubit>(() => GetSingleUserCubit(
      getSingleUserUseCases: sl.call()
  ));

  sl.registerFactory<CredentialCubit>(() => CredentialCubit(
      createUserUseCases: sl.call(),
      signInUseCases: sl.call(),
      verifyWithPhoneNumberUseCases: sl.call()
  ));

  sl.registerFactory<GetDeviceNumberCubit>(() => GetDeviceNumberCubit(
      getDeviceNumberUseCases: sl.call()
  ));

  // * USE CASES INJECTION

  sl.registerLazySingleton<GetCurrentUidUseCases>(() => GetCurrentUidUseCases(repository: sl.call()));

  sl.registerLazySingleton<IsSignInUseCases>(
          () => IsSignInUseCases(repository: sl.call()));

  sl.registerLazySingleton<SignOutUseCases>(
          () => SignOutUseCases(repository: sl.call()));

  sl.registerLazySingleton<CreateUserUseCases>(
          () => CreateUserUseCases(repository: sl.call()));

  sl.registerLazySingleton<GetAllUsersUseCases>(
          () => GetAllUsersUseCases(repository: sl.call()));

  sl.registerLazySingleton<UpdateUserUseCases>(
          () => UpdateUserUseCases(repository: sl.call()));

  sl.registerLazySingleton<GetSingleUserUseCases>(
          () => GetSingleUserUseCases(repository: sl.call()));

  sl.registerLazySingleton<SignInWithPhoneNumberUseCases>(
          () => SignInWithPhoneNumberUseCases(repository: sl.call()));

  sl.registerLazySingleton<VerifyPhoneNumberUseCases>(
          () => VerifyPhoneNumberUseCases(repository: sl.call()));

  sl.registerLazySingleton<GetDeviceNumberUseCases>(
          () => GetDeviceNumberUseCases(repository: sl.call()));

  // * REPOSITORY & DATA SOURCES INJECTION

  sl.registerLazySingleton<UserRepository>(
          () => UserRepositoryImp(userRemoteDataSource: sl.call()));

  sl.registerLazySingleton<UserRemoteDataSource>(() => UserImpRemoteDataSource(
    auth: sl.call(),
    store: sl.call(),
  ));

}