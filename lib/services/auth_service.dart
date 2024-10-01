import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_unipass/config/config_url.dart'; // Importa la configuración
import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';

class AuthServices {
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
      await AuthUtils.saveUserId(
          userData['user']['IdLogin']); // Guarda el IdUser
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

  Future<bool> updatePassword(String correo, String newPassword) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/password/$correo'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'NewPassword': newPassword}),
      );

      if (response.statusCode == 200) {
        return true; // Contraseña actualizada con éxito
      } else if (response.statusCode == 404) {
        throw Exception(
            'No se pudo actualizar la contraseña: Usuario no encontrado');
      } else {
        throw Exception('Error al actualizar la contraseña: ${response.body}');
      }
    } catch (e) {
      throw Exception('Fallo en la actualización de la contraseña: $e');
    }
  }
}
