import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_unipass/config/config_url.dart';

class BedroomService {
  Future<int?> obtenerDormitorio(String? nivelAcademico, String? sexo) async {
    final response =
        await http.get(Uri.parse('$baseUrl/dormitorio/$sexo/$nivelAcademico'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['IdBedroom'];
    } else {
      print(
          'Fallo al obtener el id del dormitorio. Status code: ${response.statusCode}');
    }
    return null;
  }
}
