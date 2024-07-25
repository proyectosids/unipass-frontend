import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/models/users.dart';
import 'package:flutter_application_unipass/services/register_service.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';

class ConfirmDataUser extends StatefulWidget {
  static const routeName = '/confirmData';
  final String userId;

  const ConfirmDataUser({Key? key, required this.userId}) : super(key: key);

  @override
  State<ConfirmDataUser> createState() => _ConfirmDataUserState();
}

class _ConfirmDataUserState extends State<ConfirmDataUser> {
  late Future<UserData> futureUserData;

  @override
  void initState() {
    super.initState();
    futureUserData = RegisterService().getDatosUser(widget.userId);
  }

  String checkEmpty(String? value) {
    return (value == null || value.isEmpty) ? 'N/A' : value;
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(5);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Confirmacion de informacion'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<UserData>(
        future: futureUserData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;
            return ListView(
              padding: EdgeInsets.all(padding),
              children: [
                Text(
                  'TIPO DE USUARIO:',
                  style: TextStyle(
                    fontSize: responsive.dp(1.6),
                  ),
                ),
                Text(
                  checkEmpty(userData.type),
                  style: TextStyle(
                      fontSize: responsive.dp(1.8),
                      fontWeight: FontWeight.bold),
                ),
                if (userData.type == 'ALUMNO' &&
                    userData.students != null &&
                    userData.students!.isNotEmpty) ...[
                  Text(
                    'ESTUDIANTE:',
                    style: TextStyle(
                      fontSize: responsive.dp(1.6),
                    ),
                  ),
                  Text(
                    '${checkEmpty(userData.students![0].nombre)} ${checkEmpty(userData.students![0].apellidos)}',
                    style: TextStyle(
                        fontSize: responsive.dp(1.8),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'CELULAR:',
                    style: TextStyle(
                      fontSize: responsive.dp(1.6),
                    ),
                  ),
                  Text(
                    checkEmpty(userData.students![0].celular),
                    style: TextStyle(
                        fontSize: responsive.dp(1.8),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'MATRICULA:',
                    style: TextStyle(
                      fontSize: responsive.dp(1.6),
                    ),
                  ),
                  Text(
                    checkEmpty(userData.students![0].matricula),
                    style: TextStyle(
                        fontSize: responsive.dp(1.8),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'CORREO INSTITUCIONAL:',
                    style: TextStyle(
                      fontSize: responsive.dp(1.6),
                    ),
                  ),
                  Text(
                    checkEmpty(userData.students![0].correoInstitucional),
                    style: TextStyle(
                        fontSize: responsive.dp(1.8),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'NIVEL EDUCATIVO:',
                    style: TextStyle(
                      fontSize: responsive.dp(1.6),
                    ),
                  ),
                  Text(
                    checkEmpty(userData.students![0].nivelAcademico),
                    style: TextStyle(
                        fontSize: responsive.dp(1.8),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'ESCUELA:',
                    style: TextStyle(
                      fontSize: responsive.dp(1.6),
                    ),
                  ),
                  Text(
                    checkEmpty(userData.students![0].nombreEscuela),
                    style: TextStyle(
                        fontSize: responsive.dp(1.8),
                        fontWeight: FontWeight.bold),
                  ),
                ],
                if (userData.type == 'ALUMNO' &&
                    userData.tutors != null &&
                    userData.tutors!.isNotEmpty) ...[
                  Text(
                    'TUTOR:',
                    style: TextStyle(
                      fontSize: responsive.dp(1.6),
                    ),
                  ),
                  Text(
                    '${checkEmpty(userData.tutors![0].nombre)} ${checkEmpty(userData.tutors![0].apellidos)}',
                    style: TextStyle(
                        fontSize: responsive.dp(1.8),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'CELULAR TUTOR:',
                    style: TextStyle(
                      fontSize: responsive.dp(1.6),
                    ),
                  ),
                  Text(
                    checkEmpty(userData.tutors![0].celular),
                    style: TextStyle(
                        fontSize: responsive.dp(1.8),
                        fontWeight: FontWeight.bold),
                  ),
                ],
                if (userData.type == 'ALUMNO' &&
                    userData.works != null &&
                    userData.works!.isNotEmpty) ...[
                  Text(
                    'DEPARTAMENTO:',
                    style: TextStyle(
                      fontSize: responsive.dp(1.6),
                    ),
                  ),
                  Text(
                    checkEmpty(userData.works![0].nombreDepartamento),
                    style: TextStyle(
                        fontSize: responsive.dp(1.8),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'JEFE DEPARTAMENTO:',
                    style: TextStyle(
                      fontSize: responsive.dp(1.6),
                    ),
                  ),
                  Text(
                    checkEmpty(userData.works![0].jefeDepartamento),
                    style: TextStyle(
                        fontSize: responsive.dp(1.8),
                        fontWeight: FontWeight.bold),
                  ),
                ],
                if (userData.type == 'EMPLEADO' &&
                    userData.employees != null &&
                    userData.employees!.isNotEmpty) ...[
                  Text(
                    'EMPLEADO:',
                    style: TextStyle(
                      fontSize: responsive.dp(1.6),
                    ),
                  ),
                  Text(
                    '${checkEmpty(userData.employees![0].nombres)} ${checkEmpty(userData.employees![0].apellidos)}',
                    style: TextStyle(
                        fontSize: responsive.dp(1.8),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'CELULAR:',
                    style: TextStyle(
                      fontSize: responsive.dp(1.6),
                    ),
                  ),
                  Text(
                    checkEmpty(userData.employees![0].celular),
                    style: TextStyle(
                        fontSize: responsive.dp(1.8),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'MATRICULA:',
                    style: TextStyle(
                      fontSize: responsive.dp(1.6),
                    ),
                  ),
                  Text(
                    checkEmpty(userData.employees![0].matricula.toString()),
                    style: TextStyle(
                        fontSize: responsive.dp(1.8),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'CORREO INSTITUCIONAL:',
                    style: TextStyle(
                      fontSize: responsive.dp(1.6),
                    ),
                  ),
                  Text(
                    checkEmpty(userData.employees![0].emailInstitucional),
                    style: TextStyle(
                        fontSize: responsive.dp(1.8),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'DEPARTAMENTO:',
                    style: TextStyle(
                      fontSize: responsive.dp(1.6),
                    ),
                  ),
                  Text(
                    checkEmpty(userData.employees![0].departamento),
                    style: TextStyle(
                        fontSize: responsive.dp(1.8),
                        fontWeight: FontWeight.bold),
                  ),
                ],
                SizedBox(height: responsive.hp(20)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, '/verificationAccount');
                    print('Datos confirmados');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: responsive.hp(1.6)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(responsive.wp(10)),
                    ),
                  ),
                  child: Text(
                    'CONTINUAR',
                    style: TextStyle(
                      fontSize: responsive.dp(1.8),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data found.'));
          }
        },
      ),
    );
  }
}
