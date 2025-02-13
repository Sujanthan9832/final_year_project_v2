import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  late FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationService._internal() {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  /// Initialize notification service
  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(settings);

    // ✅ Request notification permission (for Android 13+)
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  /// Send notification
  Future<void> sendNotification() async {
    debugPrint("🚀 Sending notification...");

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'emotion_alert',
      'Emotion Detection',
      channelDescription:
          'Notifies when sad emotion is detected multiple times',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    try {
      await _notificationsPlugin.show(
        0,
        "⚠️ Emotional Alert",
        "Sad emotion detected 3 times in a row!",
        details,
      );
    } catch (e) {
      debugPrint("❌ Error sending notification: $e");
    }
  }
}
