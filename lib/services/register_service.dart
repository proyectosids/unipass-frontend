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
