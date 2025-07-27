import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hr_tcc/data/repositories/poll_repository_imp.dart';
import 'package:hr_tcc/data/repositories/repositories.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';
import 'package:hr_tcc/domain/services/network_service.dart';
import 'package:hr_tcc/domain/usecases/usecases.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hr_tcc/data/services/services.dart';

import '../core/logging/app_logger.dart';
import '../data/datasources/access_token_local_data_source.dart';
import '../data/datasources/current_user_local_data_source.dart';
import '../data/datasources/local/auth_local_data_source.dart';
import '../data/datasources/local/auth_local_data_source_impl.dart';
import '../data/datasources/remote/auth_remote_data_source.dart';
import '../data/datasources/remote/auth_remote_data_source_impl.dart';
import '../data/logging/app_logger_impl.dart';
import '../data/repositories/absence_request_repository_mock.dart';
import '../data/repositories/access_token_repository_impl.dart';
import '../data/repositories/business_trip_request_repository_mock.dart';
import '../data/repositories/car_brand_repository_mock.dart';
import '../data/repositories/current_user_repository_impl.dart';
import '../data/repositories/violation_request_repository_mock.dart';
import '../data/services/network_info_impl.dart';
import '../domain/repositories/access_token_repository.dart';
import '../domain/repositories/business_trip_request_repository.dart';
import '../domain/repositories/car_brand_repository.dart';
import '../domain/repositories/current_user_repository.dart';
import '../domain/repositories/parking_request_repository.dart';
import '../domain/repositories/parking_request_repository_mock.dart';
import '../domain/services/network_info.dart';
import '../presentation/cubits/auth/auth_cubit.dart';
import '../presentation/cubits/snackbar/snackbar_cubit.dart';
import '../presentation/navigation/app_router.dart';

Future<void> initDI() async {
  final getIt = GetIt.instance;

  _registerExternal(getIt);
  await _awaitExternal(getIt);
  _registerServices(getIt);
  _registerDataSources(getIt);
  _registerRepositories(getIt);
  _registerUseCases(getIt);
  _registerCubits(getIt);
  _registerAppRouter(getIt);
  _registerLogger(getIt);
}

void _registerExternal(GetIt getIt) {
  getIt.registerLazySingleton(() => Logger());
  getIt.registerSingletonAsync(() async => const FlutterSecureStorage());
  getIt.registerSingletonAsync(
    () async => await SharedPreferences.getInstance(),
  );
  getIt.registerLazySingleton(() => LocalAuthentication());
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => InternetConnectionChecker.createInstance());
}

Future<void> _awaitExternal(GetIt getIt) async {
  await getIt.isReady<FlutterSecureStorage>();
  await getIt.isReady<SharedPreferences>();
}

void _registerServices(GetIt getIt) {
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<InternetConnectionChecker>()),
  );
  getIt.registerLazySingleton<NetworkService>(
    () => NetworkServiceImpl(getIt<Dio>(), getIt<AccessTokenRepository>()),
  );
}

void _registerDataSources(GetIt getIt) {
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt<FlutterSecureStorage>()),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<NetworkService>()),
  );
  getIt.registerLazySingleton<AccessTokenLocalDataSource>(
    () => AccessTokenLocalDataSourceImpl(
      secureStorage: getIt<FlutterSecureStorage>(),
    ),
  );
  getIt.registerLazySingleton<CurrentUserLocalDataSource>(
    () => CurrentUserLocalDataSourceImpl(
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );
}

void _registerRepositories(GetIt getIt) {
  getIt.registerLazySingleton<PincodeRepository>(
    () => PincodeRepositoryImpl(getIt<FlutterSecureStorage>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<AuthLocalDataSource>(),
      getIt<NetworkInfo>(),
    ),
  );
  getIt.registerLazySingleton<RequestsRepository>(
    () => MockRequestsRepository(),
  );
  getIt.registerLazySingleton<RequestTypesRepository>(
    () => MockRequestTypesRepository(),
  );
  getIt.registerLazySingleton<PollRepository>(() => PollRepositoryImp());
  getIt.registerLazySingleton<LinkRepository>(
    () => LinkRepositoryImpl(getIt<NetworkService>()),
  );
  getIt.registerLazySingleton<ResaleRepository>(() => ResaleRepositoryImp());
  getIt.registerLazySingleton<AdressBookRepository>(
    () => AdressBookRepositoryImp(),
  );
  getIt.registerLazySingleton<NewsListRepository>(
    () => NewsListRepositoryImp(),
  );
  getIt.registerLazySingleton<TwoNdflRepository>(() => TwoNdflRepositoryImp());
  getIt.registerLazySingleton<WorkBookRepository>(
    () => WorkBookRequestRepositoryImp(),
  );
  getIt.registerLazySingleton<AbsenceRequestRepository>(
    () => AbsenceRequestRepositoryMock(),
  );
  getIt.registerLazySingleton<AccessTokenRepository>(
    () => AccessTokenRepositoryImpl(
      accessTokenLocalDataSource: getIt<AccessTokenLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<CurrentUserRepository>(
    () => CurrentUserRepositoryImpl(
      currentUserLocalDataSource: getIt<CurrentUserLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<BusinessTripRequestRepository>(
    () => BusinessTripRequestRepositoryMock(),
  );
  getIt.registerLazySingleton<ViolationRequestRepository>(
    () => ViolationRequestRepositoryMock(),
  );
  getIt.registerLazySingleton<ParkingRequestRepository>(
    () => ParkingRequestRepositoryMock(),
  );
  getIt.registerLazySingleton<CarBrandRepository>(
    () => CarBrandRepositoryMock(),
  );

  getIt.registerLazySingleton<PollQuestionRepository>(
    () => PollQuestionRepositoryImp(),
  );
}

void _registerUseCases(GetIt getIt) {
  getIt.registerLazySingleton(
    () => UpdatePincodeUseCase(getIt<PincodeRepository>()),
  );
  getIt.registerLazySingleton(
    () => VerifyPinUseCase(getIt<PincodeRepository>()),
  );
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
    () => LogoutUseCase(
      getIt<AuthRepository>(),
      getIt<PincodeRepository>(),
      getIt<CurrentUserRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => FetchRequestsUseCase(getIt<RequestsRepository>()),
  );
  getIt.registerLazySingleton(
    () => FetchRequestTypesUseCase(getIt<RequestTypesRepository>()),
  );
  getIt.registerLazySingleton(
    () => FetchRequestTypesCountUseCase(getIt<RequestTypesRepository>()),
  );
  getIt.registerLazySingleton(
    () => FetchResaleItemsUseCase(getIt<ResaleRepository>()),
  );
  getIt.registerLazySingleton(
    () => FetchTwoNdflRequestDetailsUseCase(getIt<TwoNdflRepository>()),
  );
  getIt.registerLazySingleton(
    () => FetchWorkBookRequestDetailsUseCase(getIt<WorkBookRepository>()),
  );
  getIt.registerLazySingleton(
    () => FetchPollsListUseCase(getIt<PollRepository>()),
  );
  getIt.registerLazySingleton(
    () => FetchNewsListUseCase(getIt<NewsListRepository>()),
  );
  getIt.registerLazySingleton(
    () => FetchAddressBookUseCase(getIt<AdressBookRepository>()),
  );
  getIt.registerLazySingleton(
    () => FetchAddressBookTotalCountUseCase(getIt<AdressBookRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetAbsenceRequestUseCase(getIt<AbsenceRequestRepository>()),
  );
  getIt.registerLazySingleton(
    () => FeatchLinkContentUseCase(getIt<LinkRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetBusinessTripRequestUseCase(getIt<BusinessTripRequestRepository>()),
  );
  getIt.registerLazySingleton(
    () => SubmitViolationRequestUseCase(getIt<ViolationRequestRepository>()),
  );
  getIt.registerLazySingleton(
    () => CreateParkingRequestUseCase(getIt<ParkingRequestRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetCarBrandsUseCase(getIt<CarBrandRepository>()),
  );
  getIt.registerLazySingleton(
    () => FetchPollDetailUseCase(getIt<PollQuestionRepository>()),
  );
  getIt.registerLazySingleton(
    () => SafePollDetailUseCase(getIt<PollQuestionRepository>()),
  );
}

void _registerCubits(GetIt getIt) {
  getIt.registerLazySingleton(
    () => AuthCubit(getIt<AuthRepository>(), getIt<PincodeRepository>()),
  );
  getIt.registerLazySingleton(() => SnackBarCubit());
}

void _registerAppRouter(GetIt getIt) {
  getIt.registerSingleton(AppRouter(getIt<PincodeRepository>()));
}

void _registerLogger(GetIt getIt) {
  getIt.registerLazySingleton<AppLogger>(
    () => AppLoggerImpl(logger: getIt<Logger>()),
  );
}
