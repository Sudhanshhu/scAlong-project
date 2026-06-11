import '../../data/models/portfolio_model.dart';

abstract class PortfolioRepository {
  Future<Portfolio> getPortfolio();
}
