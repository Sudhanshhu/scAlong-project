import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../bloc/dashboard_cubit.dart';
import '../bloc/dashboard_state.dart';
import 'package:midchains_customer_portal/src/common/widgets/k_text.dart';
import 'package:midchains_customer_portal/src/core/theme/app_theme.dart';

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
          final portfolio = state.portfolio;

          return RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().refreshDashboard(),
            color: theme.colorScheme.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const KText(
                            'Hello, Sam',
                            style: KTextStyle.displayMedium,
                            fontWeight: FontWeight.bold,
                          ),
                          KText(
                            'Here is your portfolio overview',
                            style: KTextStyle.bodyMedium,
                            color: theme.colorScheme.onBackground.withOpacity(0.5),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(Icons.person, color: theme.colorScheme.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Balance Card
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.08),
                            theme.colorScheme.surface,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KText(
                            'Total Wallet Balance',
                            style: KTextStyle.bodyMedium,
                            color: theme.colorScheme.onBackground.withOpacity(0.5),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              KText(
                                '${portfolio.currency} ',
                                style: KTextStyle.titleLarge,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryEmerald,
                              ),
                              KText(
                                portfolio.totalBalance.toStringAsFixed(2),
                                style: KTextStyle.displayMedium,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // Custom Sparkline Performance Chart
                          SizedBox(
                            height: 120,
                            child: LineChart(
                              LineChartData(
                                gridData: const FlGridData(show: false),
                                titlesData: const FlTitlesData(show: false),
                                borderData: FlBorderData(show: false),
                                lineTouchData: const LineTouchData(enabled: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: portfolio.balanceHistory
                                        .asMap()
                                        .entries
                                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                                        .toList(),
                                    isCurved: true,
                                    barWidth: 3,
                                    color: AppTheme.primaryEmerald,
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        colors: [
                                          AppTheme.primaryEmerald.withOpacity(0.25),
                                          AppTheme.primaryEmerald.withOpacity(0.0),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    dotData: const FlDotData(show: false),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Holdings Section Header
                  const KText(
                    'Your Holdings',
                    style: KTextStyle.titleLarge,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 16),

                  // Assets List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: portfolio.holdings.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final asset = portfolio.holdings[index];
                      final isPositive = asset.change24h >= 0;

                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.outline.withOpacity(0.1),
                            child: Icon(
                              asset.assetSymbol == 'BTC'
                                  ? Icons.currency_bitcoin
                                  : (asset.assetSymbol == 'ETH'
                                      ? Icons.diamond_outlined
                                      : Icons.account_balance),
                              color: asset.assetSymbol == 'BTC'
                                  ? Colors.orange
                                  : (asset.assetSymbol == 'ETH'
                                      ? Colors.blue
                                      : theme.colorScheme.primary),
                            ),
                          ),
                          title: KText(
                            asset.assetName,
                            style: KTextStyle.titleMedium,
                            fontWeight: FontWeight.bold,
                          ),
                          subtitle: KText(
                            '${asset.amount} ${asset.assetSymbol}',
                            style: KTextStyle.bodyMedium,
                            color: theme.colorScheme.onBackground.withOpacity(0.5),
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              KText(
                                '${portfolio.currency} ${asset.valueInCurrency.toStringAsFixed(2)}',
                                style: KTextStyle.titleMedium,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(height: 4),
                              if (asset.change24h != 0.0)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                      color: isPositive ? Colors.green : Colors.red,
                                      size: 20,
                                    ),
                                    KText(
                                      '${asset.change24h.abs().toStringAsFixed(2)}%',
                                      style: KTextStyle.bodyMedium,
                                      color: isPositive ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                )
                              else
                                KText(
                                  '-',
                                  style: KTextStyle.bodyMedium,
                                  color: theme.colorScheme.onBackground.withOpacity(0.4),
                                ),
                            ],
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
}
