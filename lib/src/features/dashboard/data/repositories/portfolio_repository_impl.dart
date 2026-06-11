import '../../domain/repositories/portfolio_repository.dart';
import '../models/portfolio_model.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  @override
  Future<Portfolio> getPortfolio() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return Portfolio(
      totalBalance: 274382.50,
      currency: 'AED',
      balanceHistory: [240000.0, 248000.0, 245000.0, 255000.0, 268000.0, 272000.0, 274382.50],
      holdings: [
        AssetHolding(
          assetName: 'Bitcoin',
          assetSymbol: 'BTC',
          amount: 1.45,
          valueInCurrency: 187425.20,
          change24h: 4.25,
        ),
        AssetHolding(
          assetName: 'Ethereum',
          assetSymbol: 'ETH',
          amount: 8.20,
          valueInCurrency: 62145.80,
          change24h: -1.15,
        ),
        AssetHolding(
          assetName: 'UAE Dirham',
          assetSymbol: 'AED',
          amount: 24811.50,
          valueInCurrency: 24811.50,
          change24h: 0.00,
        ),
      ],
    );
  }
}
