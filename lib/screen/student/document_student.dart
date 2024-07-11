import 'package:flutter_application_unipass/services/document_service.dart';
import 'package:flutter_application_unipass/utils/auth_utils.dart';
import 'package:flutter_application_unipass/utils/imports.dart';

class DocumentStudent extends StatefulWidget {
  static const routeName = '/documentStudent';
  const DocumentStudent({super.key});

  @override
  State<DocumentStudent> createState() => _DocumentStudentState();
}

class _DocumentStudentState extends State<DocumentStudent> {
  Map<String, bool> documents = {
    'Reglamento ULV': false,
    'Reglamento dormitorio': false,
    'Acuerdo de consentimiento': false,
    'Convenio de salidas': false,
  };

  Map<String, String?> documentFiles = {
    'Reglamento ULV': null,
    'Reglamento dormitorio': null,
    'Acuerdo de consentimiento': null,
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
    if (userId == null) return;

    try {
      List<Map<String, dynamic>> userDocuments =
          await _documentService.getDocumentsByUser(userId);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        for (var doc in userDocuments) {
          String documentName = _getDocumentNameById(doc['IdDocumento']);
          documents[documentName] = true;
          documentFiles[documentName] = doc['Archivo'];
          prefs.setBool('${documentName}_isUploaded', true);
          prefs.setString('${documentName}_fileName', doc['Archivo']);
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
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.insert_drive_file),
                      title: Text(key),
                      subtitle: fileName != null
                          ? Text('Archivo adjunto: $fileName')
                          : null,
                      trailing: Icon(
                        value ? Icons.check_circle : Icons.cancel,
                        color: value ? Colors.green : Colors.red,
                      ),
                      onTap: () async {
                        final result = await Navigator.of(context).pushNamed(
                          DocumentAddStudent.routeName,
                          arguments: {
                            'documentName': key,
                            'isUploaded': value,
                            'fileName': fileName,
                          },
                        ) as Map<String, dynamic>?;

                        if (result != null) {
                          setState(() {
                            documents[key] = result['isUploaded'];
                            documentFiles[key] = result['fileName'];
                          });
                          _saveDocumentState(
                              key, result['isUploaded'], result['fileName']);
                        }
                      },
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
