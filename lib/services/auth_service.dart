import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_unipass/config/config_url.dart'; // Importa la configuración
import 'package:flutter_application_unipass/utils/auth_utils.dart';

Future<Map<String, dynamic>> authenticateUser(
    String matricula, String correo, String contrasena) async {
  final response = await http.post(
    Uri.parse(
        '$baseUrl/login'), // Utiliza la constante baseUrl desde el archivo de configuración
    headers: {'Content-Type': 'application/json'},
    body: json.encode(
        {'Matricula': matricula, 'Correo': correo, 'Contraseña': contrasena}),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> userData = json.decode(response.body);
    await AuthUtils.saveUserId(userData['user']['IdLogin']); // Guarda el IdUser
    return userData;
  } else {
    throw Exception('Failed to authenticate user');
  }
}

Future<Map<String, dynamic>?> getUserInfo(int userId) async {
  final response = await http.get(Uri.parse('$baseUrl/user/$userId'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load user info');
  }
}
