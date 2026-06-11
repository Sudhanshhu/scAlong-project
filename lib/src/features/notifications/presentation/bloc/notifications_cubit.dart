import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/notifications_repository.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsCubit(this._repository) : super(NotificationsInitial());

  Future<void> loadNotifications() async {
    emit(NotificationsLoading());
    try {
      final list = await _repository.getNotifications();
      emit(NotificationsLoaded(list));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _repository.markAsRead(id);
      final list = await _repository.getNotifications();
      emit(NotificationsLoaded(list));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _repository.markAllAsRead();
      final list = await _repository.getNotifications();
      emit(NotificationsLoaded(list));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }
}
