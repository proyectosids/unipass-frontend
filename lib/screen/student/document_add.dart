import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentAddStudent extends StatefulWidget {
  static const routeName = '/documentAddStudent'; // Ruta nombrada
  final String documentName;
  final bool isUploaded;
  final String? initialFileName;

  const DocumentAddStudent({
    required this.documentName,
    required this.isUploaded,
    this.initialFileName,
    super.key,
  });

  @override
  State<DocumentAddStudent> createState() => _DocumentAddStudentState();
}

class _DocumentAddStudentState extends State<DocumentAddStudent> {
  bool isFileAttached = false;
  String? fileName;
  File? file;

  @override
  void initState() {
    super.initState();
    isFileAttached = widget.isUploaded;
    fileName = widget.initialFileName;
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
        file = File(result.files.single.path!);
        isFileAttached = true;
      });
    }
  }

  Future<void> _removeFile() async {
    setState(() {
      fileName = null;
      file = null;
      isFileAttached = false;
    });
  }

  Future<void> _onSave() async {
    if (isFileAttached && file != null) {
      final uri = Uri.parse(
          'http://localhost:3000/doctos'); // Ajusta esta URL según tu configuración
      final request = http.MultipartRequest('POST', uri);

      request.files.add(await http.MultipartFile.fromPath('file', file!.path));
      request.fields['IdDocumento'] =
          '1'; // Ajusta estos campos según tus necesidades
      request.fields['IdUser'] = '1';

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = json.decode(responseData);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool(
            '${widget.documentName}_isUploaded', isFileAttached);
        await prefs.setString(
            '${widget.documentName}_fileName', fileName ?? '');
        await prefs.setString(
            '${widget.documentName}_fileUrl', data['Archivo'] ?? '');

        Navigator.of(context)
            .pop({'isUploaded': isFileAttached, 'fileName': fileName});
      } else {
        // Maneja el error aquí
        print('Error uploading file');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentName),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estado',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isFileAttached ? 'Aceptado' : 'Pendiente',
              style: TextStyle(
                fontSize: 16,
                color: isFileAttached ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Adjuntar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.attach_file,
                        size: 40,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isFileAttached
                            ? 'Archivo adjunto: $fileName'
                            : 'Agregar un archivo aquí',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            if (isFileAttached) // Mostrar botón de quitar solo si hay un archivo adjunto
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _removeFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text(
                    'Quitar documento',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    (isFileAttached && fileName != null) ? _onSave : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (isFileAttached && fileName != null)
                      ? Colors.orange
                      : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text(
                  'Enviar documento',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
