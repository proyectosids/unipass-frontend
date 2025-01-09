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

    // Configura el manejo de mensajes en segundo plano
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Configura el manejo de mensajes cuando la app está en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    // Configura el manejo de mensajes cuando la app se inicia desde una notificación cerrada
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleMessage(message);
      }
    });

    // Configura el manejo de mensajes cuando la app se abre desde una notificación en segundo plano
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    // Aquí puedes agregar más lógica según los datos recibidos
  }

  void _handleMessage(RemoteMessage message) {
    // Este método centraliza el manejo de notificaciones
    if (message.notification != null) {
      LocalNotification.showLocalNotification(
        id: 0,
        title: message.notification!.title ?? 'No title',
        body: message.notification!.body ?? 'No body',
        data: message.data.toString(),
      );
    }
  }
}
