import 'package:flutter_application_unipass/services/local_notification.dart';
import 'package:flutter_application_unipass/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal() {
    _init();
  }

  Future<void> _init() async {
    await LocalNotification
        .initializeLocalNotifications(); // Usar tu método inicializador
  }

  Future<void> showNotification(
      String title, String body, String payload) async {
    LocalNotification.showLocalNotification(
        id: 0,
        title: title,
        body: body,
        data: payload); // Usar tu método para mostrar notificaciones
  }
}
