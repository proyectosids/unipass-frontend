import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_application_unipass/config/config_url.dart';

class DocumentService {
  Future<String> uploadDocument(File file, int idDocumento, int idUser) async {
    final uri = Uri.parse('$baseUrl/doctos');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.fields['IdDocumento'] = idDocumento.toString();
    request.fields['IdUser'] = idUser.toString();

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = json.decode(responseData);
      return data['Archivo'];
    } else {
      throw Exception('Failed to upload document');
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

  Future<void> deleteDocument(int id, int idUser) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/doctos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'IdUser': idUser}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete document');
    }
  }
}
