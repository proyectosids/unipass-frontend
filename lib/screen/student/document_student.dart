import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/config/config_url.dart';
import 'package:flutter_application_unipass/services/document_service.dart';
import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
import 'package:flutter_application_unipass/utils/imports.dart';

class DocumentStudent extends StatefulWidget {
  static const routeName = '/documentStudent';
  const DocumentStudent({super.key});

  @override
  State<DocumentStudent> createState() => _DocumentStudentState();
}

class _DocumentStudentState extends State<DocumentStudent> {
  Map<String, bool> documents = {
    'INE del Tutor': false,
    'Reglamento dormitorio': false,
    'Convenio de salidas': false,
  };

  Map<String, String?> documentFiles = {
    'INE del Tutor': null,
    'Reglamento dormitorio': null,
    'Convenio de salidas': null,
  };

  Map<String, int?> documentIds = {
    'INE del Tutor': null,
    'Reglamento dormitorio': null,
    'Convenio de salidas': null,
  };

  final DocumentService _documentService = DocumentService();

  @override
  void initState() {
    super.initState();
    _loadDocumentStates();
  }

  Future<void> _loadDocumentStates() async {
    int? userId = await AuthUtils.getUserId();
    if (userId == null) {
      print('User ID is null');
      return;
    }

    try {
      List<Map<String, dynamic>> userDocuments =
          await _documentService.getDocumentsByUser(userId);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        for (var doc in userDocuments) {
          String documentName = _getDocumentNameById(doc['IdDocumento']);
          if (documents.containsKey(documentName)) {
            documents[documentName] = true;
            documentFiles[documentName] = doc['Archivo'];
            documentIds[documentName] = doc['IdDocumento'];
            prefs.setBool('${documentName}_isUploaded', true);
            prefs.setString('${documentName}_fileName', doc['Archivo']);
          }
        }
      });
    } catch (e) {
      print('Error loading documents: $e');
    }
  }

  String _getDocumentNameById(int id) {
    switch (id) {
      case 1:
        return 'Reglamento ULV';
      case 2:
      case 3:
      case 4:
      case 5:
        return 'Reglamento dormitorio';
      case 6:
        return 'Acuerdo de consentimiento';
      case 7:
        return 'Convenio de salidas';
      case 9:
        return 'INE del Tutor';
      default:
        return 'Documento desconocido';
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

  Future<void> _deleteDocument(String documentName) async {
    if (documents[documentName] == false) {
      print('No se puede eliminar un documento que no está adjunto.');
      return;
    }

    int? userId = await AuthUtils.getUserId();
    if (userId == null) {
      print('User ID is null');
      return;
    }

    try {
      int? documentId = documentIds[documentName];
      if (documentId != null) {
        await _documentService.deleteDocument(userId, documentId);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('${documentName}_isUploaded', false);
        await prefs.remove('${documentName}_fileName');

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const DocumentStudent(),
          ),
        );
      }
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse('$baseUrl$url');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int completedDocuments = documents.values.where((e) => e).length;
    double progress = completedDocuments / documents.length;
    bool isComplete = progress == 1.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Documentos',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Para poder solicitar una salida es necesario tener estos documentos adjuntos en tu aplicación',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isComplete ? Colors.green : Colors.yellow,
                          ),
                          strokeWidth: 10,
                        ),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: TextStyle(
                          fontSize: 24,
                          color: isComplete ? Colors.green : Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  String key = documents.keys.elementAt(index);
                  bool value = documents[key]!;
                  String? fileName = documentFiles[key];

                  return Dismissible(
                    key: Key(key),
                    direction: value
                        ? DismissDirection.endToStart
                        : DismissDirection.none,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) async {
                      await _deleteDocument(key);
                    },
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.insert_drive_file),
                        title: Text(key),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              value ? Icons.check_circle : Icons.cancel,
                              color: value ? Colors.green : Colors.red,
                            ),
                          ],
                        ),
                        onTap: () async {
                          if (value && fileName != null) {
                            _launchURL(fileName);
                          } else {
                            final result =
                                await Navigator.of(context).pushNamed(
                              DocumentAddStudent.routeName,
                              arguments: {
                                'documentName': key,
                                'isUploaded': value,
                                'fileName': fileName,
                              },
                            );

                            if (result != null) {
                              setState(() {
                                _loadDocumentStates();
                              });
                            }
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
