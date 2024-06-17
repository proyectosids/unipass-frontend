import 'package:flutter/material.dart';

class DocumentStudent extends StatefulWidget {
  static const routeName = '/documentStudent';
  const DocumentStudent({super.key});

  @override
  State<DocumentStudent> createState() => _DocumentStudentState();
}

class _DocumentStudentState extends State<DocumentStudent> {
  Map<String, bool> documents = {
    'Reglamento ULV': true,
    'Reglamento dormitorio': true,
    'Antidoping': false,
    'Acuerdo Salidas': false,
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
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Row(
              children: [
                Expanded(
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
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  String key = documents.keys.elementAt(index);
                  bool value = documents[key]!;
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.insert_drive_file),
                      title: Text(key),
                      trailing: Icon(
                        value ? Icons.check_circle : Icons.cancel,
                        color: value ? Colors.green : Colors.red,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DocumentUploadScreen(
                              documentName: key,
                              isUploaded: value,
                              onUpload: (status) {
                                setState(() {
                                  documents[key] = status;
                                });
                              },
                            ),
                          ),
                        );
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

class DocumentUploadScreen extends StatefulWidget {
  final String documentName;
  final bool isUploaded;
  final Function(bool) onUpload;

  const DocumentUploadScreen({
    required this.documentName,
    required this.isUploaded,
    required this.onUpload,
  });

  @override
  _DocumentUploadScreenState createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  bool _isUploaded = false;

  @override
  void initState() {
    super.initState();
    _isUploaded = widget.isUploaded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isUploaded ? 'Documento adjuntado' : 'Documento no adjuntado',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isUploaded = !_isUploaded;
                  widget.onUpload(_isUploaded);
                });
              },
              child: Text(
                  _isUploaded ? 'Eliminar documento' : 'Adjuntar documento'),
            ),
          ],
        ),
      ),
    );
  }
}
