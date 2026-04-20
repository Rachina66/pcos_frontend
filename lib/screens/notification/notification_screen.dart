import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/notification/notification_model.dart';
import '../../providers/notification/notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB565A7),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          if (provider.unreadCount > 0)
            TextButton(
              onPressed: () => provider.markAllAsRead(),
              child: const Text(
                'Mark all read',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
        ],
      ),
      body: provider.loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFB565A7)),
            )
          : provider.notifications.isEmpty
          ? _buildEmpty()
          : RefreshIndicator(
              color: const Color(0xFFB565A7),
              onRefresh: () => provider.fetchNotifications(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: provider.notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final n = provider.notifications[index];
                  return _buildNotificationCard(context, n, provider);
                },
              ),
            ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationModel n,
    NotificationProvider provider,
  ) {
    return GestureDetector(
      onTap: () {
        if (!n.read) provider.markAsRead(n.id);
        _handleTap(context, n);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: n.read ? Colors.white : const Color(0xFFFDF0FB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: n.read
                ? Colors.transparent
                : const Color(0xFFB565A7).withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Icon ──
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _iconColor(n.type).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _iconData(n.type),
                color: _iconColor(n.type),
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            // ── Content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          n.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: n.read
                                ? FontWeight.w500
                                : FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (!n.read)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFB565A7),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    n.body,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _timeAgo(n.createdAt),
                    style: const TextStyle(fontSize: 11, color: Colors.black38),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFB565A7).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_outlined,
              size: 48,
              color: Color(0xFFB565A7),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'You\'ll see updates about your\nappointments here',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  void _handleTap(BuildContext context, NotificationModel n) {
    final appointmentId = n.data['appointmentId'];
    if (appointmentId != null) {
      Navigator.pushNamed(
        context,
        '/appointment-results',
        arguments: appointmentId,
      );
    }
  }

  IconData _iconData(String type) {
    switch (type) {
      case 'APPOINTMENT_CONFIRMED':
        return Icons.check_circle_outline;
      case 'APPOINTMENT_CANCELLED':
        return Icons.cancel_outlined;
      case 'APPOINTMENT_COMPLETED':
        return Icons.task_alt_outlined;
      case 'APPOINTMENT_NOTES_ADDED':
        return Icons.description_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _iconColor(String type) {
    switch (type) {
      case 'APPOINTMENT_CONFIRMED':
        return const Color(0xFF4CAF50);
      case 'APPOINTMENT_CANCELLED':
        return const Color(0xFFE53935);
      case 'APPOINTMENT_COMPLETED':
        return const Color(0xFF9C27B0);
      case 'APPOINTMENT_NOTES_ADDED':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFFB565A7);
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
