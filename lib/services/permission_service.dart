import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_unipass/config/config_url.dart';
import 'package:flutter_application_unipass/models/permission.dart';
import 'package:flutter_application_unipass/services/register_service.dart';

class PermissionService {
  final RegisterService _registerService;

  PermissionService(this._registerService);

  Future<List<Permission>> getPermissions(int id, String matricula) async {
    // Obtener datos del usuario
    final userResponse = await _registerService.getDatosUser(matricula);
    final userData = userResponse.toJson();

    // Verificar que los datos del usuario no sean nulos
    if (userData == null ||
        userData['student'] == null ||
        userData['student'].isEmpty) {
      throw Exception('Invalid user data received from API');
    }

    // Obtener permisos
    final response = await http.get(Uri.parse('$baseUrl/permission/$id'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      // Verificar que los datos de permisos no sean nulos
      if (data == null) {
        throw Exception('Invalid permissions data received from API');
      }

      // Combinar datos del usuario con permisos
      return data.map<Permission>((permissionJson) {
        return Permission.fromJson(permissionJson, userData);
      }).toList();
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

  Future<List<Permission>> getPermissionForAutorizacion(
      String idEmpleado) async {
    final response =
        await http.get(Uri.parse('$baseUrl/permissionsEmployee/$idEmpleado'));

    if (response.statusCode == 200) {
      List<dynamic> permissionData = json.decode(response.body);

      if (permissionData == null) {
        throw Exception('Informacion no recibida de la API');
      }

      List<Permission> permissionsEmployee = [];
      for (var permissionJson in permissionData) {
        String matricula = permissionJson['Matricula'];
        // Obtener datos del usuario para cada permiso
        final userResponse = await _registerService.getDatosUser(matricula);
        final userData = userResponse.toJson();

        //Verificar los datos del usuario
        if (userData == null ||
            userData['student'] == null ||
            userData['student'].isEmpty) {
          throw Exception('Informacion del usuario no recibida de la API');
        }

        //Combinar datos para el modelo
        Permission permission = Permission.fromJson(permissionJson, userData);
        permissionsEmployee.add(permission);
      }
      return permissionsEmployee;
    } else {
      throw Exception('Fallo en la carga de permisos para autorizacion');
    }
  }
}
