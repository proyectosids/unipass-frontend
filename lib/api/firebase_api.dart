import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_application_unipass/services/local_notification.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseApi() {
    initNotifications();
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fCMToken');

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleMessage(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  void _handleMessage(RemoteMessage message) {
    int notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);

    // Llama a showLocalNotification para cada mensaje individual
    LocalNotification.showLocalNotification(
      id: notificationId,
      title: message.notification?.title ?? 'No title',
      body: message.notification?.body ?? 'No body',
      data: message.data.toString(),
      groupKey: 'com.tuapp.group_key',
    );

    // Llama a showGroupSummaryNotification para mantener el resumen del grupo actualizado
    LocalNotification.showGroupSummaryNotification(
      groupKey: 'com.tuapp.group_key',
      title: "Notificaciones Agrupadas",
      body: "Tienes nuevas notificaciones agrupadas.",
    );
  }
}
