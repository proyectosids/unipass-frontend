import 'dart:convert';
import 'package:flutter_application_unipass/config/config_url.dart';
import 'package:http/http.dart' as http;

class ChecksService {
  // Servicio para crear todos los checks delos dormitorios y vigilancia por donde tenga que pasar
  Future<void> solicitarCreacionChecks(
      int idPermiso, String accion, int idPoint) async {
    final response = await http.post(Uri.parse('$baseUrl/checks'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "Accion": accion,
          "IdPoint": '$idPoint',
          "IdPermission": '$idPermiso',
        }));
    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Error al crear la autorizacion');
    }
  }

  // Servicio para obtener todos los checks pendientes por autorizar en los dormitorios
  Future<List<dynamic>> obtenerChecksDormitorio(int idDormitorio) async {
    final response = await http.get(
        Uri.parse('$baseUrl/checksDormitorio/$idDormitorio'),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener los checks del dormitorio');
    }
  }

  Future<List<dynamic>> obtenerChecksDormitorioFin(int idDormitorio) async {
    final response = await http.get(
        Uri.parse('$baseUrl/checksDormitorioFin/$idDormitorio'),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener los checks del dormitorio');
    }
  }

  // Servicio para obtener todos los checks pendientes por autorizar en vigilancia
  Future<List<dynamic>> obtenerChecksVigilancia() async {
    final response = await http.get(Uri.parse('$baseUrl/checksVigilancia'),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener los checks del dormitorio');
    }
  }

  // Servicio para actualizar el estado del Check
  Future<void> actualizarEstadoCheck(
      int idCheck, String estado, String observacion) async {
    // Ajuste a la zona horaria de México (UTC -6)
    DateTime now = DateTime.now();
    DateTime mexicoTime = now.toUtc().subtract(const Duration(hours: 6));

    final response = await http.put(
      Uri.parse('$baseUrl/checks/$idCheck'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'Estatus': estado,
        'FechaCheck': mexicoTime.toIso8601String(),
        'Observaciones': observacion // Fecha ajustada a México
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el estado del check');
    }
  }
}
