import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_unipass/config/config_url.dart';

class AuthorizeService {
  Future<void> asignarAuthorice(
      int idEmpleado, int noDepto, int idPermission) async {
    final response = await http.post(Uri.parse('$baseUrl/authorize'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            "IdEmpleado": '$idEmpleado',
            "NoDepto": '$noDepto',
            "IdPermission": '$idPermission',
          },
        ));

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Error al crear la authorizacion');
    }
  }

  Future<int?> asignarPreceptor(String NivelAcademico, String sexo) async {
    final uri = Uri.parse('$baseUrl/asignarPrece/$NivelAcademico?Sexo=$sexo');
    final respuesta = await http.get(uri);

    if (respuesta.statusCode == 200) {
      final data = json.decode(respuesta.body);
      return int.parse(data['Identificador']);
    } else {
      print(
          'Fallo al obtener el preceptor. Status code: ${respuesta.statusCode}');
      return null;
    }
  }
}
