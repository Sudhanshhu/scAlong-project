import '../../data/models/portfolio_model.dart';

abstract class PortfolioRepository {
  /// Loads the dashboard home data (user name + any linked wallets) from the
  /// real backend endpoints.
  Future<DashboardData> getDashboard();
}
