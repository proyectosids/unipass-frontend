import 'package:flutter_application_unipass/utils/imports.dart';

class ChangepasswordStudent extends StatefulWidget {
  static const routeName = '/changeStudent';
  const ChangepasswordStudent({super.key});

  @override
  State<ChangepasswordStudent> createState() => _ChangepasswordStudentState();
}

class _ChangepasswordStudentState extends State<ChangepasswordStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Cambiar contraseña'),
      ),
    );
  }
}
