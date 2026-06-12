import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/account_cubit.dart';
import '../bloc/account_state.dart';
import 'package:midchains_customer_portal/src/common/widgets/k_text.dart';

class AccountDetailsView extends StatefulWidget {
  const AccountDetailsView({super.key});

  @override
  State<AccountDetailsView> createState() => _AccountDetailsViewState();
}

class _AccountDetailsViewState extends State<AccountDetailsView> {
  @override
  void initState() {
    super.initState();
    context.read<AccountCubit>().loadAccountDetails();
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          KText(label, style: KTextStyle.bodyMedium, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
          KText(value, style: KTextStyle.bodyMedium, fontWeight: FontWeight.bold),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 56, color: theme.colorScheme.onSurface.withValues(alpha: 0.25)),
          const SizedBox(height: 16),
          KText(title, style: KTextStyle.titleMedium, fontWeight: FontWeight.bold),
          const SizedBox(height: 8),
          KText(
            message,
            style: KTextStyle.bodyMedium,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
      case 'VERIFIED':
      case 'COMPLIANT':
      case 'ACTIVE':
        return Colors.green;
      case 'PENDING_APPROVAL':
      case 'PENDING':
        return Colors.amber;
      case 'REJECTED':
      case 'FAILED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        if (state is AccountLoading || state is AccountInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AccountError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                KText(state.message, style: KTextStyle.bodyMedium),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<AccountCubit>().loadAccountDetails(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is AccountLoaded) {
          final info = state.personalInfo;
          final kyc = state.kycStatus;
          final docs = state.documents;
          final wallet = state.wallet;
          final fatca = state.fatca;
          final bank = state.bank;

          return DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                title: const KText('Account Details', style: KTextStyle.titleLarge, fontWeight: FontWeight.bold),
                bottom: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: theme.colorScheme.primary,
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  tabs: const [
                    Tab(text: 'Profile'),
                    Tab(text: 'KYC Status'),
                    Tab(text: 'Banks & Wallets'),
                    Tab(text: 'FATCA / CRS'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  // TAB 1: Profile Personal Info
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const KText('Personal Information', style: KTextStyle.titleLarge, fontWeight: FontWeight.bold),
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            child: Column(
                              children: [
                                _buildInfoRow(context, 'First Name', info.firstName),
                                const Divider(height: 1),
                                _buildInfoRow(context, 'Last Name', info.lastName),
                                const Divider(height: 1),
                                _buildInfoRow(context, 'Email Address', info.email),
                                const Divider(height: 1),
                                _buildInfoRow(context, 'Phone Number', info.phone),
                                const Divider(height: 1),
                                _buildInfoRow(context, 'Nationality', info.nationality),
                                const Divider(height: 1),
                                _buildInfoRow(context, 'Date of Birth', info.dateOfBirth),
                                const Divider(height: 1),
                                _buildInfoRow(context, 'Gender', info.gender),
                                const Divider(height: 1),
                                _buildInfoRow(context, 'Address', info.address),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // TAB 2: KYC Status
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const KText('KYC Verification', style: KTextStyle.titleLarge, fontWeight: FontWeight.bold),
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const KText('Verification Status', style: KTextStyle.titleMedium, fontWeight: FontWeight.bold),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(kyc.kycStatus).withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: KText(
                                        kyc.kycStatus.replaceAll('_', ' '),
                                        style: KTextStyle.labelLarge,
                                        fontWeight: FontWeight.bold,
                                        color: _getStatusColor(kyc.kycStatus),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                _buildInfoRow(context, 'Verification Level', kyc.level.replaceAll('_', ' ')),
                                const SizedBox(height: 20),
                                const KText('Completed Steps', style: KTextStyle.titleMedium, fontWeight: FontWeight.bold),
                                const SizedBox(height: 12),
                                ...kyc.completedSteps.map((step) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.check_circle, color: Colors.green, size: 20),
                                          const SizedBox(width: 8),
                                          KText(step.replaceAll('_', ' '), style: KTextStyle.bodyMedium),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        if (docs.isNotEmpty) ...[
                          const SizedBox(height: 32),
                          const KText('Uploaded Documents', style: KTextStyle.titleLarge, fontWeight: FontWeight.bold),
                          const SizedBox(height: 16),
                          ...docs.map((doc) => Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: theme.colorScheme.primaryContainer,
                                    child: Icon(Icons.badge_outlined, color: theme.colorScheme.primary),
                                  ),
                                  title: KText(doc.docType.replaceAll('_', ' '), style: KTextStyle.titleMedium, fontWeight: FontWeight.bold),
                                  subtitle: KText('No: ${doc.docNumber} | Exp: ${doc.expiryDate}', style: KTextStyle.bodyMedium, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(doc.status).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: KText(
                                      doc.status,
                                      style: KTextStyle.labelLarge,
                                      fontWeight: FontWeight.bold,
                                      color: _getStatusColor(doc.status),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ],
                    ),
                  ),

                  // TAB 3: Banks & Wallets
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const KText('Linked Bank Account', style: KTextStyle.titleLarge, fontWeight: FontWeight.bold),
                        const SizedBox(height: 16),
                        if (bank == null)
                          _buildEmptyState(
                            context,
                            icon: Icons.account_balance_outlined,
                            title: 'No Bank Linked',
                            message: 'You have not linked a bank account yet.',
                          )
                        else
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      KText(bank.bankName, style: KTextStyle.titleMedium, fontWeight: FontWeight.bold),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(bank.status).withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: KText(
                                          bank.status,
                                          style: KTextStyle.labelLarge,
                                          fontWeight: FontWeight.bold,
                                          color: _getStatusColor(bank.status),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  _buildInfoRow(context, 'Account Number', bank.accountNumber),
                                  const Divider(height: 1),
                                  _buildInfoRow(context, 'Currency', bank.currency),
                                  const Divider(height: 1),
                                  _buildInfoRow(context, 'IBAN', bank.iban),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 32),
                        const KText('Crypto Wallet Address', style: KTextStyle.titleLarge, fontWeight: FontWeight.bold),
                        const SizedBox(height: 16),
                        if (!wallet.linked)
                          _buildEmptyState(
                            context,
                            icon: Icons.account_balance_wallet_outlined,
                            title: 'No Wallet Linked',
                            message: 'You have not added a crypto wallet yet.',
                          )
                        else
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      KText(wallet.network, style: KTextStyle.titleMedium, fontWeight: FontWeight.bold),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(wallet.status).withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: KText(
                                          wallet.status,
                                          style: KTextStyle.labelLarge,
                                          fontWeight: FontWeight.bold,
                                          color: _getStatusColor(wallet.status),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  const KText('Wallet Address', style: KTextStyle.bodyMedium),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.outline.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            wallet.walletAddress,
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontFamily: 'monospace',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.copy_outlined, size: 20),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(text: wallet.walletAddress));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Wallet address copied to clipboard'),
                                                duration: Duration(seconds: 1),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // TAB 4: FATCA / CRS
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const KText('Tax Compliance (FATCA / CRS)', style: KTextStyle.titleLarge, fontWeight: FontWeight.bold),
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const KText('FATCA Status', style: KTextStyle.titleMedium, fontWeight: FontWeight.bold),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(fatca.fatcaStatus).withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: KText(
                                        fatca.fatcaStatus,
                                        style: KTextStyle.labelLarge,
                                        fontWeight: FontWeight.bold,
                                        color: _getStatusColor(fatca.fatcaStatus),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                _buildInfoRow(context, 'US Tax Resident', fatca.isUSTaxResident ? 'Yes' : 'No'),
                                const Divider(height: 1),
                                _buildInfoRow(context, 'Residency Country', fatca.taxResidencyCountry),
                                const Divider(height: 1),
                                _buildInfoRow(context, 'CRS Compliance', fatca.crsStatus),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
