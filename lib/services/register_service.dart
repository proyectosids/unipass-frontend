import 'package:flutter_application_unipass/models/users.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_unipass/config/config_url.dart';

class RegisterService {
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
}
