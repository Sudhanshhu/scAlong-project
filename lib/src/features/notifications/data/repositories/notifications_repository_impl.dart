import '../../domain/repositories/notifications_repository.dart';
import '../models/notification_model.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final List<NotificationModel> _mockNotifications = [
    NotificationModel(
      id: '1',
      title: 'Security Alert: New Login',
      message: 'A new login was detected on your account from a Chrome browser on macOS.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationModel(
      id: '2',
      title: 'AED Deposit Confirmed',
      message: 'Your deposit of 24,811.50 AED from Emirates NBD bank has been successfully credited to your wallet.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      id: '3',
      title: 'Welcome to Midchains!',
      message: 'Thank you for opening an account with Midchains. Complete your KYC level 2 verification to unlock high-volume trading.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
  ];

  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.from(_mockNotifications);
  }

  @override
  Future<void> markAsRead(String id) async {
    final index = _mockNotifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _mockNotifications[index].isRead = true;
    }
  }

  @override
  Future<void> markAllAsRead() async {
    for (var n in _mockNotifications) {
      n.isRead = true;
    }
  }
}
