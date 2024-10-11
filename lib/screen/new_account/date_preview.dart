import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/models/users.dart';
import 'package:flutter_application_unipass/services/otp_service.dart';
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
  final OtpServices _otpServices = OtpServices();

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
    final double padding = responsive.wp(3);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
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
            final isAlumno = userData.type == 'ALUMNO';
            final dynamic user =
                isAlumno ? userData.students!.first : userData.employees!.first;

            final userInfo = {
              'matricula': user.matricula,
              'nombres': isAlumno ? user.nombre : user.nombres,
              'apellidos': user.apellidos,
              'residencia': isAlumno ? user.residencia : 'NA',
              'sexo': user.sexo,
              'correoInstitucional':
                  isAlumno ? user.correoInstitucional : user.emailInstitucional,
              'fechaNacimiento': user.fechaNacimiento.toIso8601String(),
              'celular': user.celular,
              'type': userData.type,
              'nivelAcademico': isAlumno ? user.nivelAcademico : 'NA',
            };

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(padding),
                    children: [
                      // Sección de Información Personal
                      Text(
                        'Información Personal',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.dp(2.0),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        title: Text(
                          'Nombre',
                          style: TextStyle(
                            fontSize: responsive.dp(1.5),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        trailing: Text(
                          checkEmpty(isAlumno ? user.nombre : user.nombres),
                          style: TextStyle(
                            fontSize: responsive.dp(1.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Apellidos',
                          style: TextStyle(
                            fontSize: responsive.dp(1.5),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        trailing: Text(
                          checkEmpty(user.apellidos),
                          style: TextStyle(
                            fontSize: responsive.dp(1.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Tipo de usuario:',
                          style: TextStyle(
                            fontSize: responsive.dp(1.5),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        trailing: Text(
                          checkEmpty(userData.type),
                          style: TextStyle(
                            fontSize: responsive.dp(1.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Correo Institucional',
                          style: TextStyle(
                            fontSize: responsive.dp(1.5),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        trailing: Text(
                          checkEmpty(isAlumno
                              ? user.correoInstitucional
                              : user.emailInstitucional),
                          style: TextStyle(
                            fontSize: responsive.dp(1.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Residencia',
                          style: TextStyle(
                            fontSize: responsive.dp(1.5),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        trailing: Text(
                          checkEmpty(userData.students![0].residencia),
                          style: TextStyle(
                            fontSize: responsive.dp(1.6),
                            fontWeight: FontWeight.bold,
                          ), // Aquí agregas los puntos suspensivos
                          maxLines: 2, // Limita a una sola línea
                        ),
                      ),

                      ListTile(
                        title: Text(
                          'N° Celular',
                          style: TextStyle(
                            fontSize: responsive.dp(1.5),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        trailing: Text(
                          checkEmpty(user.celular),
                          style: TextStyle(
                            fontSize: responsive.dp(1.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isAlumno)
                        ListTile(
                          title: Text(
                            'Nivel Académico',
                            style: TextStyle(
                              fontSize: responsive.dp(1.5),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          trailing: Text(
                            checkEmpty(user.nivelAcademico),
                            style: TextStyle(
                              fontSize: responsive.dp(1.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const Divider(),
                      // Sección de Información del Tutor
                      if (isAlumno &&
                          userData.tutors != null &&
                          userData.tutors!.isNotEmpty) ...[
                        Text(
                          'Información del Tutor',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.dp(2.0),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListTile(
                          title: Text(
                            'Nombre',
                            style: TextStyle(
                              fontSize: responsive.dp(1.5),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          trailing: Text(
                            '${checkEmpty(userData.tutors![0].nombre)} \n${checkEmpty(userData.tutors![0].apellidos)}',
                            style: TextStyle(
                              fontSize: responsive.dp(1.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'N° Celular',
                            style: TextStyle(
                              fontSize: responsive.dp(1.5),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          trailing: Text(
                            checkEmpty(userData.tutors![0].celular),
                            style: TextStyle(
                              fontSize: responsive.dp(1.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(),
                      ],
                      // Sección de Información del Departamento
                      if (isAlumno &&
                          userData.works != null &&
                          userData.works!.isNotEmpty) ...[
                        Text(
                          'Información del Departamento',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.dp(2.0),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListTile(
                          title: Text(
                            'Nombre',
                            style: TextStyle(
                              fontSize: responsive.dp(1.5),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          trailing: Text(
                            checkEmpty(userData.works![0].nombreDepartamento),
                            style: TextStyle(
                              fontSize: responsive.dp(1.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Encargado',
                            style: TextStyle(
                              fontSize: responsive.dp(1.5),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          trailing: Text(
                            checkEmpty(userData.works![0].jefeDepartamento),
                            style: TextStyle(
                              fontSize: responsive.dp(1.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: SizedBox(
                    width: responsive
                        .wp(60), // Botón ocupa todo el ancho disponible
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await _otpServices.launchOTP(isAlumno
                              ? user.correoInstitucional
                              : user.emailInstitucional);

                          print("OTP enviado con éxito");

                          if (userData.type == 'EMPLEADO') {
                            final registerService = RegisterService();
                            bool? validojefe = await registerService
                                .getValidarJefe(userData.employees![0].matricula
                                    .toString());
                            if (validojefe != true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'El usuario no es un jefe de departamento')),
                              );
                              return;
                            }
                          }
                          if (userData.type == 'ALUMNO') {
                            if (!isAlumno ||
                                userData.students![0].residencia != 'INTERNO') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Necesitas ser un alumno interno')),
                              );
                              return;
                            }
                          }

                          Navigator.pushReplacementNamed(
                              context, '/verificationAccount',
                              arguments: userInfo);
                          print('Datos confirmados');
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al enviar OTP: $e')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(250, 198, 0, 1),
                        padding:
                            EdgeInsets.symmetric(vertical: responsive.hp(1.6)),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(responsive.wp(10)),
                        ),
                      ),
                      child: Text(
                        'CONTINUAR',
                        style: TextStyle(
                          fontSize: responsive.dp(1.8),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
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
