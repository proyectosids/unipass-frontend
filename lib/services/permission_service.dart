import 'package:flutter_application_unipass/services/authorize_service.dart';
import 'package:flutter_application_unipass/utils/imports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_unipass/config/config_url.dart';
import 'package:flutter_application_unipass/models/permission.dart';
import 'package:flutter_application_unipass/services/register_service.dart';

class PermissionService {
  final RegisterService _registerService;
  final AuthorizeService _authorizeService;

  PermissionService(this._registerService, this._authorizeService);

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
      final permissionCreated = json.decode(response.body);
      print(permissionCreated);
      int idPermission = permissionCreated['Id'];
      int idTipoSalida = permissionCreated['IdTipoSalida'];
      DateTime fechsalida =
          DateTime.parse(permissionCreated['FechaSalida']); // Si es DateTime
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? idDepto = prefs.getInt('idDepto');
      int? idJefe = prefs.getInt('idJefe');
      String? nivelAcdemico = prefs.getString('nivelAcademico');
      String? matricula = prefs.getString('matricula');
      String? sexo = prefs.getString('sexo');
      final asigPreceptor =
          await _authorizeService.asignarPreceptor(nivelAcdemico!, sexo!);
      print(asigPreceptor);
      final idPrece = await _registerService.getPreceptor(asigPreceptor!);
      print(idPrece);

      // Obtén el día de la semana directamente de fechsalida
      int diaSemana = fechsalida.weekday; // Obtiene el día de la semana
      //Pendiente arreglar la el retorno de los datos del coordinador con
      //matricula y iddepto
      if (idTipoSalida == 4) {
        final encBiblio = await _registerService.getEncargadoDepto(204);
        final encFinanzasEst = await _registerService.getEncargadoDepto(265);
        final coordinador = await _registerService.getCordinador(matricula!);
        final encVidaUtil = await _registerService.getEncargadoDepto(333);
        await _authorizeService.asignarAuthorice(encBiblio!, 204, idPermission);
        await _authorizeService.asignarAuthorice(
            encFinanzasEst!, 265, idPermission);
        await _authorizeService.asignarAuthorice(
            int.tryParse(coordinador!['empMatricula'].toString()) ?? 0,
            int.tryParse(coordinador['IdDepartamento'].toString()) ?? 0,
            idPermission);
        await _authorizeService.asignarAuthorice(
            encVidaUtil!, 333, idPermission);
        await _authorizeService.asignarAuthorice(
            asigPreceptor, idDepto!, idPermission);
      }

      if (idPrece != idJefe && diaSemana != 6 && idTipoSalida != 4) {
        await _authorizeService.asignarAuthorice(
            idJefe!, idDepto!, idPermission);
        await _authorizeService.asignarAuthorice(
            idPrece!, asigPreceptor, idPermission);
      } else if (idPrece == idJefe || idTipoSalida == 2 && diaSemana == 6) {
        // Verifica si es sábado (6)
        // Aquí puedes manejar el caso cuando la fecha de salida es sábado
        await _authorizeService.asignarAuthorice(
            idPrece!, asigPreceptor, idPermission);
        print("La fecha de salida es un sábado.");
      }

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

  Future<List<Permission>> getPermissionForAutorizacionPrece(
      String idEmpleado) async {
    final response =
        await http.get(Uri.parse('$baseUrl/PermissionsPreceptor/$idEmpleado'));

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

  Future<void> terminarPermission(
      int idPermiso, String valorar, String motivo) async {
    final response =
        await http.put(Uri.parse('$baseUrl/permissionValorado/$idPermiso'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(
              {
                "StatusPermission": valorar,
                "Observaciones": motivo,
              },
            ));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error valorar el permiso');
    }
  }
}
