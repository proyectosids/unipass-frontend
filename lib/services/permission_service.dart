import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_unipass/config/config_url.dart'; // Importa la configuración

class PermissionService {
  final String _baseUrl = baseUrl;

  Future<List<Map<String, dynamic>>> getPermissions() async {
    final response = await http.get(Uri.parse('$_baseUrl/permission'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load permissions');
    }
  }

  Future<Map<String, dynamic>> createPermission(
      Map<String, dynamic> newPermission) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/permission'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newPermission),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create permission');
    }
  }
}
