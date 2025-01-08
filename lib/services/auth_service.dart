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

  Future<Map<String, dynamic>?> UserInfoExt(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/InfoCargo/$userId'));

    if (response.statusCode == 200) {
      if (response.body == 'null') {
        return null;
      }
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user info');
    }
  }

  Future<Map<String, dynamic>?> UserInfoDelegado(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/InfoDelegado/$userId'));

    if (response.statusCode == 200) {
      if (response.body == 'null') {
        return null;
      }
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

  Future<Map<String, dynamic>?> getinfoMatricula(String matricula) async {
    final response =
        await http.get(Uri.parse('$baseUrl/userMatricula/$matricula'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user info');
    }
  }

  Future<dynamic> buscarpersona(String nombre) async {
    final response = await http.get(Uri.parse('$baseUrl/buscarUser/$nombre'));

    if (response.statusCode == 200) {
      print(response.body);

      final decodedResponse = json.decode(response.body);
      if (decodedResponse is List) {
        return decodedResponse; // Retorna la lista de usuarios
      } else if (decodedResponse is Map) {
        return decodedResponse; // Retorna un solo usuario en un mapa
      } else {
        throw Exception('Unexpected response format');
      }
    } else if (response.statusCode == 404) {
      // Manejar el caso de datos no encontrados
      return null; // Retorna null si no se encuentran usuarios
    } else {
      throw Exception('Failed to search user info: ${response.statusCode}');
    }
  }

  //Funciones para los Token FCM
  Future<bool> updateTokenFCM(String matricula, String tokenFCM) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/TokenDispositivo/$matricula'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'TokenCFM': tokenFCM}),
      );

      if (response.statusCode == 200) {
        return true; // Token actualizado correctamente
      } else {
        throw Exception('Failed to update token FCM: ${response.body}');
      }
    } catch (e) {
      throw Exception('Exception when updating token FCM: $e');
    }
  }

  Future<String?> searchTokenFCM(String matricula) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/VerToken/$matricula'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data.isNotEmpty ? data[0]['TokenCFM'] : null;
      } else if (response.statusCode == 404) {
        return null; // No se encontró el token
      } else {
        throw Exception('Failed to fetch token FCM: ${response.body}');
      }
    } catch (e) {
      throw Exception('Exception when fetching token FCM: $e');
    }
  }
}
