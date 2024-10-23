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
    try {
      final uri = Uri.parse('$endpointUrl/api/datos/getjefe/$idEmpleado');
      final respuesta = await http.get(uri);

      if (respuesta.statusCode == 200) {
        if (respuesta.body.isNotEmpty) {
          final data = json.decode(respuesta.body);
          // Verificar si el JSON tiene la clave 'EmpMatricula' y si coincide con idEmpleado
          if (data != null && data['EmpMatricula'] != null) {
            if (data['EmpMatricula'] == idEmpleado) {
              return true;
            } else {
              return false;
            }
          }
        } else {
          print('La respuesta del servidor está vacía.');
          return null;
        }
      } else {
        print('Error en la respuesta del servidor: ${respuesta.statusCode}');
      }
    } catch (e) {
      print('Error al intentar obtener o procesar la respuesta: $e');
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

  Future<int?> getEncargadoDepto(int noDepto) async {
    final uri = Uri.parse('$endpointUrl/api/datos/JefeDepto/$noDepto');
    final respuesta = await http.get(uri);

    if (respuesta.statusCode == 200) {
      final data = json.decode(respuesta.body);
      final matricula = data['EmpMatricula'];
      return int.tryParse(matricula);
    } else {
      print(
          'Fallo al obtener el jefe de trabajo. Status code: ${respuesta.statusCode}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCordinador(String matricula) async {
    final uri = Uri.parse('$endpointUrl/api/datos/coordinador/$matricula');
    final respuesta = await http.get(uri);

    if (respuesta.statusCode == 200) {
      final data = json.decode(respuesta.body);

      // Verifica que 'data' contiene las claves esperadas
      if (data is Map<String, dynamic> &&
          data.containsKey('empMatricula') &&
          data.containsKey('IdDepartamento')) {
        return {
          'empMatricula': data['empMatricula'],
          'IdDepartamento': data['IdDepartamento'],
        };
      } else {
        print('Respuesta no contiene las claves esperadas.');
        return null;
      }
    } else {
      print(
          'Fallo al obtener el jefe de trabajo. Status code: ${respuesta.statusCode}');
      return null;
    }
  }
}
