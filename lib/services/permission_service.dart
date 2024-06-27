import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_unipass/config/config_url.dart';

class PermissionService {
  Future<List<Map<String, dynamic>>> getPermissions() async {
    final response = await http.get(Uri.parse('$baseUrl/permission'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load permissions');
    }
  }

  Future<void> cancelPermission(int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/permission/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'StatusPermission': 'Cancelado'}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel permission');
    }
  }

  Future<Map<String, dynamic>> createPermission(
      Map<String, dynamic> permission) async {
    final response = await http.post(
      Uri.parse('$baseUrl/permission'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(permission),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create permission');
    }
  }
}
