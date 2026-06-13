import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midchains_customer_portal/src/core/di/service_locator.dart';
import 'package:midchains_customer_portal/src/features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'dashboard_home_view.dart';
import '../../../account/presentation/bloc/account_cubit.dart';
import '../../../account/presentation/screens/account_details_view.dart';
import '../../../notifications/presentation/bloc/notifications_cubit.dart';
import '../../../notifications/presentation/screens/notifications_view.dart';
import '../../../settings/presentation/bloc/settings_cubit.dart';
import '../../../settings/presentation/screens/settings_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DashboardCubit>(create: (_) => getIt<DashboardCubit>()),
        BlocProvider<AccountCubit>(create: (_) => getIt<AccountCubit>()),
        BlocProvider<NotificationsCubit>(
          create: (_) => getIt<NotificationsCubit>(),
        ),
        BlocProvider<SettingsCubit>(
          create: (_) => getIt<SettingsCubit>()..load(),
        ),
      ],
      child: const DashboardScreenContent(),
    );
  }
}

class DashboardScreenContent extends StatefulWidget {
  const DashboardScreenContent({super.key});

  @override
  State<DashboardScreenContent> createState() => _DashboardScreenContentState();
}

class _DashboardScreenContentState extends State<DashboardScreenContent> {
  int _currentIndex = 0;

  final List<Widget> _views = const [
    DashboardHomeView(),
    AccountDetailsView(),
    NotificationsView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentIndex,
          children: _views,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Account',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
