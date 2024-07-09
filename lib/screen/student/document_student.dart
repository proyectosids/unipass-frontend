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
