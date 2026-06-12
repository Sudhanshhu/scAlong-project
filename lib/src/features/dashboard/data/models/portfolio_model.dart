/// A real wallet entry returned by `/api/kyc/client-profiles/wallet`.
/// The dev account has no linked wallet, so the list comes back empty.
class WalletHolding {
  final String network;
  final String address;
  final String status;

  WalletHolding({
    required this.network,
    required this.address,
    required this.status,
  });

  factory WalletHolding.fromJson(Map<String, dynamic> json) {
    String s(dynamic v, [String fb = 'N/A']) {
      if (v == null) return fb;
      final t = v.toString().trim();
      return t.isEmpty ? fb : t;
    }

    return WalletHolding(
      network: s(json['network'] ?? json['chain']),
      address: s(json['walletAddress'] ?? json['address']),
      status: s(json['status'], 'ACTIVE'),
    );
  }
}

/// Aggregate data for the dashboard home tab. Only contains values that come
/// from real endpoints: the user's first name and any linked wallets.
class DashboardData {
  final String userName;
  final List<WalletHolding> holdings;

  DashboardData({
    required this.userName,
    required this.holdings,
  });
}
