import 'package:flutter_application_unipass/services/local_notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_unipass/config/config_url.dart';

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

  // Método ajustado para manejar la agrupación de notificaciones
  Future<void> showNotification(
      int id, String title, String body, String payload, String groupKey,
      {bool isGroupSummary = false}) async {
    LocalNotification.showLocalNotification(
      id: id,
      title: title,
      body: body,
      data: payload,
      groupKey: groupKey,
      isGroupSummary: isGroupSummary,
    );
  }

  // Método para mostrar el resumen del grupo de notificaciones
  Future<void> showGroupSummaryNotification(
      String groupKey, String title, String body) async {
    LocalNotification.showGroupSummaryNotification(
      groupKey: groupKey,
      title: title,
      body: body,
    );
  }

  // Método para enviar notificaciones a través de FCM utilizando el backend
  Future<void> sendNotificationToServer(
      String token, String title, String body) async {
    const String url =
        '$firebaseUrl/send'; // Asegúrate de que la URL es correcta
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'token': token,
          'title': title,
          'body': body,
        }),
      );

      if (response.statusCode == 200) {
        print('Notificación enviada correctamente');
      } else {
        print('Error al enviar notificación: ${response.body}');
      }
    } catch (e) {
      print('Error al conectar al servidor: $e');
    }
  }
}
