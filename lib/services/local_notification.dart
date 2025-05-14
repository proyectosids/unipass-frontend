import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeLocalNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher_foreground');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data,
    required String groupKey,
    bool isGroupSummary = false,
  }) async {
    final String groupChannelId = 'group_channel_id';
    final String groupChannelName = 'Group Channel';

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      groupChannelId,
      groupChannelName,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      groupKey: groupKey,
      setAsGroupSummary: isGroupSummary,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: data,
    );
  }

  static Future<void> showGroupSummaryNotification({
    required String groupKey,
    String? title,
    String? body,
    int id = 9999, // ID estático para el resumen del grupo
  }) async {
    showLocalNotification(
      id: id,
      title: title,
      body: body,
      groupKey: groupKey,
      isGroupSummary: true,
    );
  }
}
