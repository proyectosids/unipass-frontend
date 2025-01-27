import 'package:flutter_application_unipass/config/config_url.dart';
import 'package:flutter_application_unipass/services/auth_service.dart';
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
  final AuthServices _authServices = AuthServices();
  bool allDocumentsComplete = false;

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
      await updateDocumentStatusOnServer();
    } catch (e) {
      print('Error loading documents: $e');
    }
  }

  // Método para actualizar el estado del documento en el servidor
  Future<void> updateDocumentStatusOnServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? matricula = prefs.getString('matricula');
    int? userId = await AuthUtils.getUserId();
    if (userId == null) {
      print('User ID is null');
      return;
    }

    try {
      bool allDocumentsComplete = _isAllDocumentsComplete();
      int statusDoc =
          allDocumentsComplete ? 1 : 0; // 1 si todos completos, 0 si no
      await _authServices.updateDocumentStatus(matricula!, statusDoc);
    } catch (e) {
      print('Error updating document status: $e');
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
    bool confirmDelete = await _showDeleteConfirmationDialog();
    if (!confirmDelete) return; // Si el usuario no confirma, no hacer nada.

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

        // Actualizar el estado de los documentos inmediatamente
        setState(() {
          documents[documentName] = false;
          documentFiles[documentName] = null;
          documentIds[documentName] = null;
        });

        // Limpiar preferencias y actualizar estado en el servidor
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('${documentName}_isUploaded', false);
        await prefs.remove('${documentName}_fileName');

        await updateDocumentStatusOnServer(); // Actualiza el estado de los documentos en el servidor
      }
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text(
              '¿Estás seguro de que quieres eliminar este documento?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(false); // No proceder con la eliminación
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(true); // Proceder con la eliminación
              },
            ),
          ],
        );
      },
    );
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

  bool _isAllDocumentsComplete() {
    int completedDocuments = documents.values.where((e) => e).length;
    return completedDocuments == documents.length;
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(3);
    int completedDocuments = documents.values.where((e) => e).length;
    double progress = completedDocuments / documents.length;
    bool isComplete = progress == 1.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(6, 66, 106, 1),
        centerTitle: true,
        title: Text(
          'Documentos',
          style: TextStyle(
              color: const Color.fromRGBO(250, 198, 0, 1),
              fontSize: responsive.dp(2.2)),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(250, 198, 0, 1),
          ),
          onPressed: () {
            Navigator.pop(context,
                true); // Devuelve true si los documentos fueron actualizados
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Para solicitar una salida, es necesario tener estos documentos adjuntos en tu aplicación.',
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
              ListView.builder(
                physics:
                    const NeverScrollableScrollPhysics(), // Desactiva el scroll interno
                shrinkWrap:
                    true, // Permite que el ListView se ajuste al contenido
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  String key = documents.keys.elementAt(index);
                  bool value = documents[key]!;
                  String? fileName = documentFiles[key];
                  int? docId = documentIds[
                      key]; // Asumiendo que es un identificador único

                  return Dismissible(
                    key: Key(docId
                        .toString()), // Usa el ID del documento como clave única
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
                      bool confirmDelete =
                          await _showDeleteConfirmationDialog();
                      if (!confirmDelete) {
                        setState(
                            () {}); // Restablece el estado si la eliminación no se confirma
                        return;
                      }

                      await _deleteDocument(key);
                      //setState(() {
                      //  documents.remove(key);
                      //  documentFiles.remove(key);
                      //  documentIds.remove(key);
                      //});
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

                            // Aquí manejas el resultado para ver si necesitas recargar los estados de los documentos
                            if (result == true) {
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
            ],
          ),
        ),
      ),
    );
  }
}
