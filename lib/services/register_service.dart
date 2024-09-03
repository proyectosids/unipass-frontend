import 'package:flutter_application_unipass/models/users.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_unipass/config/config_url.dart';

class RegisterService {
  //Consumo de datos de API de la BD ULV
  Future<UserData> getDatosUser(String userId) async {
    final response =
        await http.get(Uri.parse('$endpointUrl/api/datos/$userId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body)['data'] ??
          jsonDecode(response.body)['Data'];

      // Verificar que los datos no sean nulos
      if (data == null) {
        throw Exception('Invalid data received from API');
      }

      return UserData.fromJson(data);
    } else {
      throw Exception('Failed to search user info');
    }
  }

  Future<int?> getPreceptor(int noDepto) async {
    final uri = Uri.parse('$endpointUrl/api/datos/prece/$noDepto');
    final respuesta = await http.get(uri);

    if (respuesta.statusCode == 200) {
      final data = json.decode(respuesta.body);
      return data['ID JEFE'];
    } else {
      print(
          'Fallo al obtener el jefe de trabajo. Status code: ${respuesta.statusCode}');
      return null;
    }
  }

  Future<bool?> getValidarJefe(String idEmpleado) async {
    final uri = Uri.parse('$endpointUrl/api/datos/getjefe/$idEmpleado');
    final respuesta = await http.get(uri);

    if (respuesta.statusCode == 200) {
      final data = json.decode(respuesta.body);
      if (data['EmpMatricula'] != null && data['EmpMatricula'] == idEmpleado) {
        return true;
      } else {
        return false;
      }
    }
    return null;
  }

  Future<bool?> getJefeVigilancia(String idEmpleado) async {
    final uri = Uri.parse('$endpointUrl/api/datos/vigilancia/$idEmpleado');
    final respuesta = await http.get(uri);

    if (respuesta.statusCode == 200) {
      final data = json.decode(respuesta.body);
      if (data != null && data['EmpMatricula'] == idEmpleado) {
        return true;
      } else {
        return false;
      }
    }
    return null;
  }

  //Inserccion de datos de a la BD UniPass
  Future<void> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode != 200) {
      throw Exception(
          jsonDecode(response.body)['message'] ?? 'Failed to register user');
    }
  }
}
