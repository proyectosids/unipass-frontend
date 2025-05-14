import 'dart:convert';
import 'package:flutter_application_unipass/config/config_url.dart';
import 'package:http/http.dart' as http;

class PointCheckService {
  Future<List<dynamic>> getPoints(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/getPoints/$id'));

    if (response.statusCode == 200) {
      // Si es exitoso, decodifica el cuerpo de la respuesta en JSON
      return json.decode(response.body);
    } else {
      // Si falla, lanza una excepción
      throw Exception('Error al obtener los puntos: ${response.statusCode}');
    }
  }
}
