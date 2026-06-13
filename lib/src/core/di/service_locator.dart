import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';
import '../storage/secure_storage_service.dart';
import '../theme/theme_cubit.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';

import '../../features/dashboard/data/repositories/portfolio_repository_impl.dart';
import '../../features/dashboard/domain/repositories/portfolio_repository.dart';
import '../../features/dashboard/presentation/bloc/dashboard_cubit.dart';

import '../../features/account/data/repositories/account_repository_impl.dart';
import '../../features/account/domain/repositories/account_repository.dart';
import '../../features/account/presentation/bloc/account_cubit.dart';

import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/presentation/bloc/notifications_cubit.dart';

import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/presentation/bloc/settings_cubit.dart';

/// Global service locator instance.
final GetIt getIt = GetIt.instance;

/// Registers every dependency in the object graph. Call once from `main()`
/// before `runApp`.
///
/// Layering:
///  - **Core** (`SecureStorageService`, `DioClient`) → lazy singletons.
///  - **Repositories** → lazy singletons (interface registered, impl provided),
///    so the rest of the app depends only on the domain abstraction.
///  - **Cubits** → factories (a fresh instance per screen), except [ThemeCubit]
///    which is app-wide and therefore a singleton.
void setupServiceLocator() {
  // ----- Core -----
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(secureStorageService: getIt<SecureStorageService>()),
  );

  // ----- Repositories (domain interface -> data implementation) -----
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      client: getIt<DioClient>(),
      storage: getIt<SecureStorageService>(),
    ),
  );
  getIt.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(
      client: getIt<DioClient>(),
      storage: getIt<SecureStorageService>(),
    ),
  );
  getIt.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      client: getIt<DioClient>(),
      storage: getIt<SecureStorageService>(),
    ),
  );
  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(),
  );
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(client: getIt<DioClient>()),
  );

  // ----- Presentation (BLoC/Cubit) -----
  // Factories: each screen receives its own short-lived cubit.
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));
  getIt.registerFactory<DashboardCubit>(
    () => DashboardCubit(getIt<PortfolioRepository>()),
  );
  getIt.registerFactory<AccountCubit>(
    () => AccountCubit(getIt<AccountRepository>()),
  );
  getIt.registerFactory<NotificationsCubit>(
    () => NotificationsCubit(getIt<NotificationsRepository>()),
  );
  getIt.registerFactory<SettingsCubit>(
    () => SettingsCubit(getIt<SettingsRepository>()),
  );

  // App-wide theme state → single shared instance.
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
}
