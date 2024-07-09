import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_unipass/services/auth_service.dart';
import 'dart:io';
import 'package:flutter_application_unipass/services/document_service.dart';
import 'package:flutter_application_unipass/utils/auth_utils.dart';
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

  bool isFileAttached = false;
  String? fileName;
  File? file;
  final DocumentService _documentService = DocumentService();

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
    // Recuperar idUser de SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = await AuthUtils.getUserId();
    if (id == null) {
      print('User ID not found');
      return;
    }

    Map<String, dynamic>? userInfo = await getUserInfo(id);
    if (userInfo == null) {
      print('User info not found');
      return;
    }

    // Recuperar nivel académico y sexo de SharedPreferences o algún otro método
    String nivelAcademico = userInfo['NivelAcademico'];
    String sexo = userInfo['Sexo'];
    print(nivelAcademico);
    print(sexo);

    // Determinar idDocumento
    int idDocumento =
        determineIdDocumento(widget.documentName, nivelAcademico, sexo);

    if (isFileAttached && file != null) {
      try {
        String fileUrl = await _documentService.uploadDocument(
            file!, idDocumento, id); //Los IDs necesarios para la funcion
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool(
            '${widget.documentName}_isUploaded', isFileAttached);
        await prefs.setString(
            '${widget.documentName}_fileName', fileName ?? '');
        await prefs.setString('${widget.documentName}_fileUrl', fileUrl);

        Navigator.of(context)
            .pop({'isUploaded': isFileAttached, 'fileName': fileName});
      } catch (e) {
        // Maneja el error
        print('Error uploading file: $e');
      }
    }
  }
}

int determineIdDocumento(
    String documentName, String nivelAcademico, String genero) {
  if (documentName == 'Reglamento ULV') {
    return 1;
  } else if (documentName == 'Reglamento dormitorio') {
    if (nivelAcademico == 'Bachiller' && genero == 'Hombre') {
      return 3;
    } else if (nivelAcademico == 'Universitario' && genero == 'Hombre') {
      return 2;
    } else if (nivelAcademico == 'Universitario' && genero == 'Mujer') {
      return 4;
    } else if (nivelAcademico == 'Bachiller' && genero == 'Mujer') {
      return 5;
    }
  } else if (documentName == 'Acuerdo de consentimiento') {
    return 6;
  } else if (documentName == 'Convenio de salidas') {
    return 7;
  }
  throw Exception('No matching idDocumento found');
}
