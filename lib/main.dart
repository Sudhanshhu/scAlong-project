import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/app.dart';
import 'src/core/storage/secure_storage_service.dart';
import 'src/core/network/dio_client.dart';
import 'src/features/auth/data/repositories/auth_repository_impl.dart';
import 'src/features/auth/domain/repositories/auth_repository.dart';
import 'src/features/dashboard/data/repositories/portfolio_repository_impl.dart';
import 'src/features/dashboard/domain/repositories/portfolio_repository.dart';
import 'src/features/account/data/repositories/account_repository_impl.dart';
import 'src/features/account/domain/repositories/account_repository.dart';
import 'src/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'src/features/notifications/domain/repositories/notifications_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final secureStorage = SecureStorageService();
  final dioClient = DioClient(secureStorageService: secureStorage);
  
  final authRepository = AuthRepositoryImpl(client: dioClient, storage: secureStorage);
  final portfolioRepository = PortfolioRepositoryImpl();
  final accountRepository = AccountRepositoryImpl(client: dioClient);
  final notificationsRepository = NotificationsRepositoryImpl();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SecureStorageService>.value(value: secureStorage),
        RepositoryProvider<DioClient>.value(value: dioClient),
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<PortfolioRepository>.value(value: portfolioRepository),
        RepositoryProvider<AccountRepository>.value(value: accountRepository),
        RepositoryProvider<NotificationsRepository>.value(value: notificationsRepository),
      ],
      child: App(secureStorageService: secureStorage),
    ),
  );
}
