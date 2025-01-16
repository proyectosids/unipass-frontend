import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter_application_unipass/models/paginated_permissions.dart';
import 'package:flutter_application_unipass/services/auth_service.dart';
import 'package:flutter_application_unipass/services/authorize_service.dart';
import 'package:flutter_application_unipass/services/notification_service.dart';
import 'package:flutter_application_unipass/utils/imports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_unipass/config/config_url.dart';
import 'package:flutter_application_unipass/models/permission.dart';
import 'package:flutter_application_unipass/services/register_service.dart';
import 'package:intl/intl.dart';

class PermissionService {
  final RegisterService _registerService;
  final AuthorizeService _authorizeService;
  final AuthServices _authServices;

  PermissionService(
      this._registerService, this._authorizeService, this._authServices);

  Future<PaginatedPermissions> getPermissions(int id, String matricula,
      {int page = 1, int limit = 10}) async {
    final response = await http
        .get(Uri.parse('$baseUrl/permission/$id?page=$page&limit=$limit'));
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      // Obtener datos adicionales de usuario
      final userResponse = await _registerService.getDatosUser(matricula);
      final userData = userResponse.toJson();

      // Extraer datos de permisos y pasar los dos argumentos necesarios
      List<dynamic> data = responseBody['data'];
      List<Permission> permissions = data
          .map<Permission>((json) => Permission.fromJson(json, userData))
          .toList();

      // Extraer metadatos de paginación
      final pagination = responseBody['pagination'];
      int totalItems = pagination['totalItems'];
      int totalPages = pagination['totalPages'];
      int currentPage = pagination['currentPage'];
      int limit = pagination['limit'];

      return PaginatedPermissions(
        permissions: permissions,
        totalItems: totalItems,
        totalPages: totalPages,
        currentPage: currentPage,
        limit: limit,
      );
    } else {
      throw Exception('Failed to load permissions');
    }
  }

  Future<void> cancelPermission(int id, int userId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/permission/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'StatusPermission': 'Cancelado'}),
    );

    if (response.statusCode == 200) {
      // Eliminar la caché para el usuario específico
      await APICacheManager().deleteCache("API_Permission_$userId");
      print("CACHE:DELETE");
    } else {
      throw Exception('Failed to cancel permission');
    }
  }

  Future<Map<String, dynamic>> createPermission(
      Map<String, dynamic> permission, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/permission'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(permission),
    );

    if (response.statusCode == 200) {
      // Eliminar la caché del usuario cuando se crea una nueva salida
      await APICacheManager().deleteCache("API_Permission_$userId");
      print("CACHE:DELETE");
      final permissionCreated = json.decode(response.body);
      print(permissionCreated);
      int idPermission = permissionCreated['Id'];
      int idTipoSalida = permissionCreated['IdTipoSalida'];
      DateTime fechsalida =
          DateTime.parse(permissionCreated['FechaSalida']); // Si es DateTime
      // Suponiendo que fechaSalida es un DateTime obtenido de alguna manera

      String formatoFecha =
          DateFormat('dd/MM/yyyy').format(fechsalida); // Formato de la fecha
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
        await _authorizeService.asignarAuthorice(
            encBiblio!, 204, idPermission, 'Pendiente');
        await _authorizeService.asignarAuthorice(
            encFinanzasEst!, 265, idPermission, 'Pendiente');
        await _authorizeService.asignarAuthorice(
            int.tryParse(coordinador!['empMatricula'].toString()) ?? 0,
            int.tryParse(coordinador['IdDepartamento'].toString()) ?? 0,
            idPermission,
            'Pendiente');
        await _authorizeService.asignarAuthorice(
            encVidaUtil!, 333, idPermission, 'Pendiente');
        await _authorizeService.asignarAuthorice(
            idPrece!, asigPreceptor, idPermission, 'Pendiente');
      }

      if (idPrece != idJefe && diaSemana != 6 && idTipoSalida == 1) {
        final coordinador = await _registerService.getCordinador(matricula!);
        await _authorizeService.asignarAuthorice(
            idJefe!, idDepto!, idPermission, 'Pendiente');
        await _authorizeService.asignarAuthorice(
            idPrece!, asigPreceptor, idPermission, 'Pendiente');
        //Se manda aprobada para que solo el coordinaron pueda visualizar la salidas como historial
        await _authorizeService.asignarAuthorice(
            int.tryParse(coordinador!['empMatricula'].toString()) ?? 0,
            int.tryParse(coordinador['IdDepartamento'].toString()) ?? 0,
            idPermission,
            'Aprobado');
        Map<String, dynamic>? userInfo =
            await _authServices.getUserInfo(userId);
        print(userInfo);
        String? token = await _authServices.searchTokenFCM(idJefe.toString());
        // Supongamos que decides enviar la notificación aquí
        final String? notificationToken =
            token; // Obtén el token de alguna manera
        final String title = "Solicitud de Salida al Pueblo";
        final String body =
            "${userInfo?['Nombre']} ${userInfo?['Apellidos']} ha solicitado una salida para $formatoFecha.";
        if (token != null) {
          // Llamada al servicio de notificaciones
          await NotificationService()
              .sendNotificationToServer(notificationToken!, title, body);
          print("Notificación enviada.");
        } else {
          print("No se encontró token FCM.");
        }
      } else if (idPrece == idJefe || idTipoSalida == 2 || idTipoSalida == 3) {
        // Verifica si es sábado (6)
        // Aquí puedes manejar el caso cuando la fecha de salida es sábado
        await _authorizeService.asignarAuthorice(
            idPrece!, asigPreceptor, idPermission, 'Pendiente');
        print("La fecha de salida es un sábado.");
        Map<String, dynamic>? userInfo =
            await _authServices.getUserInfo(userId);
        print(userInfo);
        String? token = await _authServices.searchTokenFCM(idPrece.toString());
        // Supongamos que decides enviar la notificación aquí
        final String? notificationToken =
            token; // Obtén el token de alguna manera
        String title = "";
        if (idTipoSalida == 2) {
          title = "Solicitud de Salida Especial";
        } else {
          title = "Solicitud de Salida a Casa";
        }

        final String body =
            "${userInfo?['Nombre']} ${userInfo?['Apellidos']} ha solicitado una salida para $formatoFecha.";
        if (token != null) {
          // Llamada al servicio de notificaciones
          await NotificationService()
              .sendNotificationToServer(notificationToken!, title, body);
          print("Notificación enviada.");
        } else {
          print("No se encontró token FCM.");
        }
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

      List<Permission> permissionsEmployee = [];
      for (var permissionJson in permissionData) {
        String matricula = permissionJson['Matricula'];
        // Obtener datos del usuario para cada permiso
        final userResponse = await _registerService.getDatosUser(matricula);
        final userData = userResponse.toJson();

        //Verificar los datos del usuario
        if (userData['student'] == null || userData['student'].isEmpty) {
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
      if (response.body == "null" || response.body.isEmpty) {
        // Retornar una lista vacía si la respuesta es `null` o vacía
        return [];
      }
      List<dynamic> permissionData = json.decode(response.body);

      List<Permission> permissionsEmployee = [];
      for (var permissionJson in permissionData) {
        String matricula = permissionJson['Matricula'];
        // Obtener datos del usuario para cada permiso
        final userResponse = await _registerService.getDatosUser(matricula);
        final userData = userResponse.toJson();

        //Verificar los datos del usuario
        if (userData['student'] == null || userData['student'].isEmpty) {
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
