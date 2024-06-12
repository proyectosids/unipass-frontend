import 'package:flutter_application_unipass/utils/imports.dart';

class DocumentStudent extends StatefulWidget {
  static const routeName = '/documentStudent';
  const DocumentStudent({super.key});

  @override
  State<DocumentStudent> createState() => _DocumentStudentState();
}

class _DocumentStudentState extends State<DocumentStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Documentos alumno'),
      ),
    );
  }
}
