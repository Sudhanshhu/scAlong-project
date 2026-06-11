class AssetHolding {
  final String assetName;
  final String assetSymbol;
  final double amount;
  final double valueInCurrency;
  final double change24h;

  AssetHolding({
    required this.assetName,
    required this.assetSymbol,
    required this.amount,
    required this.valueInCurrency,
    required this.change24h,
  });
}

class Portfolio {
  final double totalBalance;
  final String currency;
  final List<AssetHolding> holdings;
  final List<double> balanceHistory; // For chart plotting

  Portfolio({
    required this.totalBalance,
    required this.currency,
    required this.holdings,
    required this.balanceHistory,
  });
}
