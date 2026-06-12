import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard_cubit.dart';
import '../bloc/dashboard_state.dart';
import 'package:midchains_customer_portal/src/common/widgets/k_text.dart';

class DashboardHomeView extends StatefulWidget {
  const DashboardHomeView({super.key});

  @override
  State<DashboardHomeView> createState() => _DashboardHomeViewState();
}

class _DashboardHomeViewState extends State<DashboardHomeView> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading || state is DashboardInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DashboardError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                KText(state.message, style: KTextStyle.bodyMedium),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<DashboardCubit>().loadDashboard(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is DashboardLoaded) {
          final data = state.data;
          final name = data.userName.isEmpty ? 'there' : data.userName;

          return RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().refreshDashboard(),
            color: theme.colorScheme.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting row (real user name)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KText(
                              'Hello, $name',
                              style: KTextStyle.displayMedium,
                              fontWeight: FontWeight.bold,
                            ),
                            KText(
                              'Welcome to your Midchains portal',
                              style: KTextStyle.bodyMedium,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(Icons.person, color: theme.colorScheme.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Wallets section (real data)
                  const KText(
                    'Your Wallets',
                    style: KTextStyle.titleLarge,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 16),

                  if (data.holdings.isEmpty)
                    _buildEmptyWallets(context)
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.holdings.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final w = data.holdings[index];
                        return Card(
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: CircleAvatar(
                              backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.1),
                              child: Icon(Icons.account_balance_wallet_outlined,
                                  color: theme.colorScheme.primary),
                            ),
                            title: KText(
                              w.network,
                              style: KTextStyle.titleMedium,
                              fontWeight: FontWeight.bold,
                            ),
                            subtitle: KText(
                              w.address,
                              style: KTextStyle.bodyMedium,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            trailing: KText(
                              w.status,
                              style: KTextStyle.bodyMedium,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyWallets(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 16),
          const KText(
            'No Wallets Yet',
            style: KTextStyle.titleMedium,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8),
          KText(
            'You don’t have any linked wallets on your account yet.',
            style: KTextStyle.bodyMedium,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
