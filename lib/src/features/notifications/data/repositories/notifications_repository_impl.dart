import '../../domain/repositories/notifications_repository.dart';
import '../models/notification_model.dart';

/// The dev gateway exposes no notifications-list endpoint, so there is no real
/// data to show. We return an empty list (the UI renders its empty state)
/// rather than fabricating mock notifications.
class NotificationsRepositoryImpl implements NotificationsRepository {
  @override
  Future<List<NotificationModel>> getNotifications() async {
    return const <NotificationModel>[];
  }

  @override
  Future<void> markAsRead(String id) async {
    // No-op until a real notifications API is available.
  }

  @override
  Future<void> markAllAsRead() async {
    // No-op until a real notifications API is available.
  }
}
