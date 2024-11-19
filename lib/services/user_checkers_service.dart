import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_unipass/config/config_url.dart';

class UserCheckersService {
  Future<dynamic> buscarChecker(String correo) async {
    final response =
        await http.get(Uri.parse('$baseUrl/buscarCheckers/$correo'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('No hay registros de usuarios');
    }
  }

  Future<void> cambiarActividad(
      int id, int statusActividad, String matricula) async {
    final url = Uri.parse('$baseUrl/DesactivarChecker/$id');
    final body = {
      "StatusActividad": statusActividad,
      "Matricula": matricula,
    };
    try {
      final response = await http.put(url, body: json.encode(body), headers: {
        "Content-Type": "application/json",
      });
      if (response.statusCode != 200) {
        throw Exception('Error al cambiar actividad: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  Future<dynamic> deleteChecker(int id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/buscarCheckers/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('No hay registros de usuarios');
    }
  }
}
