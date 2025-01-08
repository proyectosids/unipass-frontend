import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handlerBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final FirebaseMessaging _firebasemessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // Solicitar permisos de notificación
    await _firebasemessaging.requestPermission();
    final fCMToken = await _firebasemessaging.getToken();
    print('Token: $fCMToken');

    // Gestiona los mensajes en segundo plano
    FirebaseMessaging.onBackgroundMessage(handlerBackgroundMessage);
  }
}
