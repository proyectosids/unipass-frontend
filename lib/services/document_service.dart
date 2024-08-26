import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_application_unipass/config/config_url.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class DocumentService {
  Future<void> uploadDocument(File file, int idDocumento, int idUser) async {
    final uri = Uri.parse('$baseUrl/doctosMul');
    final request = http.MultipartRequest('POST', uri);

    // Agregar campos
    request.fields['IdDocumento'] = idDocumento.toString();
    request.fields['IdLogin'] = idUser.toString();

    // Obtener el tipo MIME del archivo
    String? mimeType = lookupMimeType(file.path);
    final mediaType = mimeType != null
        ? MediaType.parse(mimeType)
        : MediaType('application', 'octet-stream');

    // Agregar el archivo a la solicitud
    request.files.add(
      await http.MultipartFile.fromPath(
        'Archivo',
        file.path,
        contentType: mediaType,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Document uploaded successfully');
      final responseData = await response.stream.bytesToString();
      print(responseData);
    } else {
      print('Failed to upload document. Status code: ${response.statusCode}');
      print(await response.stream.bytesToString());
    }
  }

  Future<String?> getProfile(int idUser, int idDocumento) async {
    print(idUser);
    print(idDocumento);
    final uri =
        Uri.parse('$baseUrl/doctosProfile/$idUser?IdDocumento=$idDocumento');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['Archivo']; // Ajustar según la respuesta de tu API
    } else {
      print('Failed to get profile image. Status code: ${response.statusCode}');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getDocuments() async {
    final response = await http.get(Uri.parse('$baseUrl/doctos'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load documents');
    }
  }

  Future<List<Map<String, dynamic>>> getDocumentsByUser(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/doctos/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load documents for user');
    }
  }

  Future<Map<String, dynamic>> getDocument(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/doctos/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load document');
    }
  }

  Future<void> deleteDocument(int idUser, int idDocumento) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/doctosMul/$idUser'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"IdDocumento": '$idDocumento'}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete document');
    }
  }
}
