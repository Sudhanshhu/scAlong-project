import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notifications_cubit.dart';
import '../bloc/notifications_state.dart';
import 'package:midchains_customer_portal/src/common/widgets/k_text.dart';
import 'package:midchains_customer_portal/src/core/theme/app_theme.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().loadNotifications();
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        if (state is NotificationsLoading || state is NotificationsInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NotificationsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                KText(state.message, style: KTextStyle.bodyMedium),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<NotificationsCubit>().loadNotifications(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is NotificationsLoaded) {
          final list = state.notifications;

          return Scaffold(
            appBar: AppBar(
              title: const KText('Notifications', style: KTextStyle.titleLarge, fontWeight: FontWeight.bold),
              actions: [
                if (list.any((n) => !n.isRead))
                  IconButton(
                    icon: const Icon(Icons.mark_email_read_outlined),
                    tooltip: 'Mark all as read',
                    onPressed: () {
                      context.read<NotificationsCubit>().markAllAsRead();
                    },
                  ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () => context.read<NotificationsCubit>().loadNotifications(),
              color: theme.colorScheme.primary,
              child: list.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 72,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          const KText(
                            'All Caught Up!',
                            style: KTextStyle.titleLarge,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 8),
                          KText(
                            'You do not have any new notifications.',
                            style: KTextStyle.bodyMedium,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: list.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final notification = list[index];

                        return Card(
                          color: notification.isRead 
                              ? theme.cardTheme.color 
                              : theme.colorScheme.primary.withValues(alpha: 0.04),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              if (!notification.isRead) {
                                context.read<NotificationsCubit>().markAsRead(notification.id);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Leading Icon indicating type
                                  CircleAvatar(
                                    backgroundColor: notification.title.toLowerCase().contains('security')
                                        ? Colors.red.shade100
                                        : (notification.title.toLowerCase().contains('deposit')
                                            ? Colors.green.shade100
                                            : Colors.blue.shade100),
                                    child: Icon(
                                      notification.title.toLowerCase().contains('security')
                                          ? Icons.warning_amber_rounded
                                          : (notification.title.toLowerCase().contains('deposit')
                                              ? Icons.check_circle_outline
                                              : Icons.campaign_outlined),
                                      color: notification.title.toLowerCase().contains('security')
                                          ? Colors.red
                                          : (notification.title.toLowerCase().contains('deposit')
                                              ? Colors.green
                                              : Colors.blue),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Text details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: KText(
                                                notification.title,
                                                style: KTextStyle.titleMedium,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            KText(
                                              _formatTimestamp(notification.timestamp),
                                              style: KTextStyle.bodyMedium,
                                              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        KText(
                                          notification.message,
                                          style: KTextStyle.bodyMedium,
                                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Unread blue dot indicator
                                  if (!notification.isRead) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      height: 8,
                                      width: 8,
                                      margin: const EdgeInsets.only(top: 8),
                                      decoration: const BoxDecoration(
                                        color: AppTheme.primaryEmerald,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
