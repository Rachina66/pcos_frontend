import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../models/notification/notification_model.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoint.dart';

class NotificationProvider extends ChangeNotifier {
  IO.Socket? _socket;
  final List<NotificationModel> _notifications = [];
  bool _loading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get loading => _loading;
  int get unreadCount => _notifications.where((n) => !n.read).length;

  // ── Connect socket and join user room ──
  void connect(String userId, String token) {
    _socket = IO.io(
      'http://${ApiEndpoints.ip}:4000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'authorization': 'Bearer $token'})
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      debugPrint('[Socket] connected');
      _socket!.emit('join', {'type': 'user', 'userId': userId});
    });

    _socket!.onDisconnect((_) {
      debugPrint('[Socket] disconnected');
    });

    _socket!.onConnectError((err) {
      debugPrint('[Socket] connect error: $err');
    });

    // ── appointment:status_updated ──
    _socket!.on('appointment:status_updated', (data) {
      final status = data['status'] ?? '';
      final typeMap = {
        'CONFIRMED': 'APPOINTMENT_CONFIRMED',
        'CANCELLED': 'APPOINTMENT_CANCELLED',
        'COMPLETED': 'APPOINTMENT_COMPLETED',
      };
      _addLiveNotification(
        type: typeMap[status] ?? 'APPOINTMENT_CONFIRMED',
        title: 'Appointment ${_capitalize(status)}',
        body:
            'Dr. ${data['doctorName']} ${status.toLowerCase()} your appointment on ${data['date']} at ${data['timeSlot']}',
        data: Map<String, dynamic>.from(data),
      );
    });

    // ── appointment:notes_added ──
    _socket!.on('appointment:notes_added', (data) {
      _addLiveNotification(
        type: 'APPOINTMENT_NOTES_ADDED',
        title: 'Consultation Notes Added',
        body: 'Your doctor added consultation notes to your appointment',
        data: Map<String, dynamic>.from(data),
      );
    });
  }

  // ── Add live socket notification to top of list ──
  void _addLiveNotification({
    required String type,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      title: title,
      body: body,
      data: data,
      read: false,
      createdAt: DateTime.now(),
    );
    _notifications.insert(0, notification);
    notifyListeners();
  }

  // ── Fetch persisted notifications from DB ──
  Future<void> fetchNotifications() async {
    _loading = true;
    notifyListeners();

    try {
      final response = await ApiClient().dio.get(ApiEndpoints.notifications);
      final List data = response.data['data'] ?? [];
      _notifications.clear();
      _notifications.addAll(
        data.map((e) => NotificationModel.fromJson(e)).toList(),
      );
    } catch (e) {
      debugPrint('[Notifications] fetch failed: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ── Mark one as read ──
  Future<void> markAsRead(String id) async {
    try {
      await ApiClient().dio.patch(ApiEndpoints.markNotificationRead(id));
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(read: true);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[Notifications] markAsRead failed: $e');
    }
  }

  // ── Mark all as read ──
  Future<void> markAllAsRead() async {
    try {
      await ApiClient().dio.patch(ApiEndpoints.markAllNotificationsRead);
      for (int i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(read: true);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('[Notifications] markAllAsRead failed: $e');
    }
  }

  // ── Disconnect on logout ──
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _notifications.clear();
    notifyListeners();
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  @override
  void dispose() {
    _socket?.dispose();
    super.dispose();
  }
}
