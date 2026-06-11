import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/portfolio_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final PortfolioRepository _repository;

  DashboardCubit(this._repository) : super(DashboardInitial());

  Future<void> loadDashboard() async {
    emit(DashboardLoading());
    try {
      final portfolio = await _repository.getPortfolio();
      emit(DashboardLoaded(portfolio));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> refreshDashboard() async {
    try {
      final portfolio = await _repository.getPortfolio();
      emit(DashboardLoaded(portfolio));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
