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
        title: const Text('Confirmación de información'),
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
            final dynamic user;
            if (isAlumno &&
                userData.students != null &&
                userData.students!.isNotEmpty) {
              user = userData.students!.first;
            } else if (!isAlumno &&
                userData.employees != null &&
                userData.employees!.isNotEmpty) {
              user = userData.employees!.first;
            } else {
              // Manejo de error o valor por defecto
              return const Center(
                  child:
                      Text('Error: No se encontró información del usuario.'));
            }

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

            return SafeArea(
              child: Column(
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
                            overflow: TextOverflow
                                .ellipsis, // Puntos suspensivos si excede
                            maxLines: 1, // Limitar a 1 línea
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
                            overflow: TextOverflow
                                .ellipsis, // Puntos suspensivos si excede
                            maxLines: 1, // Limitar a 1 línea
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
                            overflow: TextOverflow
                                .ellipsis, // Puntos suspensivos si excede
                            maxLines: 1, // Limitar a 1 línea
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
                            overflow: TextOverflow
                                .ellipsis, // Puntos suspensivos si excede
                            maxLines: 1, // Limitar a 1 línea
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
                            overflow: TextOverflow
                                .ellipsis, // Puntos suspensivos si excede
                            maxLines: 1, // Limitar a 1 línea
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
                              overflow: TextOverflow
                                  .ellipsis, // Puntos suspensivos si excede
                              maxLines: 1, // Limitar a 1 línea
                            ),
                          ),
                        const Divider(),
                        // Sección de Información del Tutor (Solo si es Alumno)
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
                              '${checkEmpty(userData.tutors![0].nombre)} ${checkEmpty(userData.tutors![0].apellidos)}',
                              style: TextStyle(
                                fontSize: responsive.dp(1.6),
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow
                                  .ellipsis, // Puntos suspensivos si excede
                              maxLines: 1, // Limitar a 1 línea
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
                              overflow: TextOverflow
                                  .ellipsis, // Puntos suspensivos si excede
                              maxLines: 1, // Limitar a 1 línea
                            ),
                          ),
                          const Divider(),
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
                                checkEmpty(
                                    userData.works![0].nombreDepartamento),
                                style: TextStyle(
                                  fontSize: responsive.dp(1.6),
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow
                                    .ellipsis, // Puntos suspensivos si excede
                                maxLines: 1, // Limitar a 1 línea
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
                              trailing: Container(
                                constraints: BoxConstraints(
                                    maxWidth: responsive
                                        .wp(50)), // 👈 límite de ancho
                                child: Text(
                                  checkEmpty(
                                      userData.works![0].jefeDepartamento),
                                  style: TextStyle(
                                    fontSize: responsive.dp(1.6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ],
                        // Sección de Información del Departamento (Si trabaja)
                        if (!isAlumno &&
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
                              'Departamento',
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
                              overflow: TextOverflow
                                  .ellipsis, // Puntos suspensivos si excede
                              maxLines: 1, // Limitar a 1 línea
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Jefe de Departamento',
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
                              overflow: TextOverflow
                                  .ellipsis, // Puntos suspensivos si excede
                              maxLines: 1, // Limitar a 1 línea
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(padding),
                    child: SizedBox(
                      width: responsive.wp(60),
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            await _otpServices.launchOTP(isAlumno
                                ? user.correoInstitucional
                                : user.emailInstitucional);

                            //Analizar el flujo del negocio que cualquier empleado pueda ingresar para poder delegar
                            // la autoridad de jefe cuando esta indispuesto o fuera de sus capacidades
                            //if (userData.type == 'EMPLEADO') {
                            //  final registerService = RegisterService();
                            //  bool? validojefe =
                            //      await registerService.getValidarJefe(userData
                            //          .employees![0].matricula
                            //          .toString());
                            //  if (validojefe != true) {
                            //    ScaffoldMessenger.of(context).showSnackBar(
                            //      const SnackBar(
                            //          content: Text(
                            //              'El usuario no es un jefe de departamento')),
                            //    );
                            //    return;
                            //  }
                            //}
                            if (userData.type == 'ALUMNO') {
                              if (!isAlumno ||
                                  userData.students![0].residencia !=
                                      'INTERNO') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Necesitas ser un alumno interno')),
                                );
                                return;
                              }
                            }

                            Navigator.pushReplacementNamed(
                                context, '/accountCredentials',
                                arguments: userInfo);
                            print('Datos confirmados');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Error al enviar OTP: $e')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(250, 198, 0, 1),
                          padding: EdgeInsets.symmetric(
                              vertical: responsive.hp(1.6)),
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
              ),
            );
          } else {
            return const Center(child: Text('No data found.'));
          }
        },
      ),
    );
  }
}
