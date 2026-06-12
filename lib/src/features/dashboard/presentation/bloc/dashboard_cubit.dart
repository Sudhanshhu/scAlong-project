import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/portfolio_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final PortfolioRepository _repository;

  DashboardCubit(this._repository) : super(DashboardInitial());

  Future<void> loadDashboard() async {
    emit(DashboardLoading());
    try {
      final data = await _repository.getDashboard();
      emit(DashboardLoaded(data));
    } catch (e) {
      emit(DashboardError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  Future<void> refreshDashboard() async {
    try {
      final data = await _repository.getDashboard();
      emit(DashboardLoaded(data));
    } catch (e) {
      emit(DashboardError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }
}
