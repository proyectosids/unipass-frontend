import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter_application_unipass/services/document_service.dart';
import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentAddStudent extends StatefulWidget {
  static const routeName = '/documentAddStudent';
  final String documentName;
  final bool isUploaded;
  final String? initialFileName;

  const DocumentAddStudent({
    required this.documentName,
    required this.isUploaded,
    this.initialFileName,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DocumentAddStudentState createState() => _DocumentAddStudentState();
}

class _DocumentAddStudentState extends State<DocumentAddStudent> {
  bool isFileAttached = false;
  String? fileName;
  File? file;
  final DocumentService _documentService = DocumentService();
  String? nivelAcademico;
  String? sexo;

  @override
  void initState() {
    super.initState();
    isFileAttached = widget.isUploaded;
    fileName = widget.initialFileName;
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nivelAcademico = prefs.getString('nivelAcademico');
      sexo = prefs.getString('sexo');
    });

    if (nivelAcademico == null || sexo == null) {
      print('Nivel académico o sexo no encontrado en SharedPreferences');
    } else {
      print('Nivel académico: $nivelAcademico, Sexo: $sexo');
    }
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fileName = null;
      file = null;
      isFileAttached = false;
    });
    await prefs.remove('${widget.documentName}_isUploaded');
    await prefs.remove('${widget.documentName}_fileName');
  }

  Future<void> _onSave() async {
    int? id = await AuthUtils.getUserId();
    if (id == null) {
      print('User ID not found');
      return;
    }

    if (nivelAcademico == null || sexo == null) {
      print('Nivel académico o sexo no encontrado en SharedPreferences');
      return;
    }

    int idDocumento =
        determineIdDocumento(widget.documentName, nivelAcademico!, sexo!);

    if (isFileAttached && file != null) {
      try {
        await _documentService.uploadDocument(file!, idDocumento, id);
        await _saveDocumentState(widget.documentName, isFileAttached, fileName);

        Navigator.of(context).pop({
          'isUploaded': isFileAttached,
          'fileName': fileName,
          'IdDocumento': idDocumento,
        });
      } catch (e) {
        print('Error uploading file: $e');
      }
    }
  }

  Future<void> _saveDocumentState(
      String documentName, bool isUploaded, String? fileName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${documentName}_isUploaded', isUploaded);
    if (fileName != null) {
      await prefs.setString('${documentName}_fileName', fileName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(5);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.documentName,
          style: TextStyle(
              color: const Color.fromRGBO(250, 198, 0, 1),
              fontSize: responsive.dp(2.2)),
        ),
        backgroundColor: const Color.fromRGBO(6, 66, 106, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: const Color.fromRGBO(250, 198, 0, 1),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado',
              style: TextStyle(
                  fontSize: responsive.dp(2), fontWeight: FontWeight.bold),
            ),
            SizedBox(height: responsive.hp(2)),
            Text(
              isFileAttached ? 'Pendiente' : 'No adjunto',
              style: TextStyle(
                fontSize: responsive.dp(1.9),
                color: isFileAttached ? Colors.orange : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.dp(3)),
            Text(
              'Adjuntar',
              style: TextStyle(
                  fontSize: responsive.dp(2), fontWeight: FontWeight.bold),
            ),
            SizedBox(height: responsive.hp(1.5)),
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(189, 188, 188, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.attach_file,
                        size: responsive.dp(4.5),
                        color: Colors.grey[700],
                      ),
                      SizedBox(height: responsive.hp(1.5)),
                      Text(
                        isFileAttached
                            ? 'Archivo adjunto: $fileName'
                            : 'Agregar un archivo aquí',
                        style: TextStyle(
                          fontSize: responsive.dp(1.9),
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
            SizedBox(height: responsive.hp(2)),
            Center(
              child: SizedBox(
                width: responsive.wp(60),
                height: responsive.hp(7),
                child: ElevatedButton(
                  onPressed:
                      (isFileAttached && fileName != null) ? _onSave : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (isFileAttached && fileName != null)
                        ? const Color.fromRGBO(250, 198, 0, 1)
                        : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(responsive.wp(4)),
                    ),
                    textStyle: TextStyle(fontSize: responsive.dp(1.2)),
                  ),
                  child: Text(
                    'Enviar documento',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.dp(2.2)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int determineIdDocumento(
    String documentName, String nivelAcademico, String genero) {
  if (documentName == 'Reglamento ULV') {
    return 1;
  } else if (documentName == 'Reglamento dormitorio') {
    if (nivelAcademico == 'Bachiller' && genero == 'M') {
      return 3;
    } else if (nivelAcademico == 'UNIVERSITARIO' && genero == 'M') {
      return 2;
    } else if (nivelAcademico == 'UNIVERSITARIO' && genero == 'F') {
      return 4;
    } else if (nivelAcademico == 'Bachiller' && genero == 'F') {
      return 5;
    }
  } else if (documentName == 'Acuerdo de consentimiento') {
    return 6;
  } else if (documentName == 'Convenio de salidas') {
    return 7;
  } else if (documentName == 'INE del Tutor') {
    return 9;
  }
  throw Exception('No matching idDocumento found');
}
