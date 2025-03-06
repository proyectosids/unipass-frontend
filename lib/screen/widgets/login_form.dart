import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_application_unipass/models/users.dart';
import 'package:flutter_application_unipass/services/auth_service.dart';
import 'package:flutter_application_unipass/services/register_service.dart'; // Importar el servicio de registro
import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
// Importar SharedPreferences
import 'package:flutter_application_unipass/utils/imports.dart';
// Importar dart:convert para usar jsonEncode

class LoginTextFields extends StatefulWidget {
  const LoginTextFields({super.key});

  @override
  State<LoginTextFields> createState() => _LoginTextFieldsState();
}

class _LoginTextFieldsState extends State<LoginTextFields> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _usernameOrEmail = '';
  String _password = '';
  final AuthServices _authService = AuthServices();

  Future<void> saveUserInfo(UserData userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (userData.students != null && userData.students!.isNotEmpty) {
      // Guardar información de estudiantes si existe
      Student student = userData.students!.first;
      await prefs.setString('nivelAcademico', student.nivelAcademico);
      await prefs.setString('sexo', student.sexo);
      await prefs.setString('matricula', student.matricula.toString());
      await prefs.setString('nombre', student.nombre);
      await prefs.setString('apellidos', student.apellidos);
      await prefs.setString('correo', student.correoInstitucional);

      if (userData.works != null && userData.works!.isNotEmpty) {
        Work work = userData.works!.first;
        await prefs.setInt('idDepto', work.idDepto);
        await prefs.setString('nombreDepartamento', work.nombreDepartamento);
        await prefs.setInt('idJefe', work.idJefe);
        await prefs.setString('trabajo', work.jefeDepartamento);
      }
    } else if (userData.employees != null && userData.employees!.isNotEmpty) {
      // Guardar información de empleados si no hay datos de estudiantes
      Employee employee = userData.employees!.first;
      await prefs.setString('sexo', employee.sexo);
      await prefs.setString('matricula', employee.matricula.toString());
      await prefs.setString('nombreDepartamento', employee.departamento);
      await prefs.setString('nombre', employee.nombres);
      await prefs.setString('apellidos', employee.apellidos);
      await prefs.setString('correo', employee.emailInstitucional);
    }
  }

  void _submit() async {
    final isOk = _formKey.currentState?.validate() ?? false;
    if (isOk) {
      // Mostrar pantalla de carga
      showDialog(
        context: context,
        barrierDismissible: false, // Evita que se cierre accidentalmente
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async =>
                false, // Evita que el usuario presione "Atrás"
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16.0),
                  Text(
                    'Iniciando sesión...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      );

      try {
        final result = await _authService.authenticateUser(
            _usernameOrEmail, _usernameOrEmail, _password);

        // Cerrar el diálogo de carga
        if (mounted) {
          Navigator.pop(context);
        }

        if (result['success']) {
          String tipoUser = result['user']['TipoUser'];
          String userId = result['user']['Matricula'];
          String newUserId = userId.replaceFirst('MTR', '');

          // Manejo de tokens FCM
          try {
            final String? currentToken =
                await _authService.searchTokenFCM(userId);
            final String? newToken =
                await FirebaseMessaging.instance.getToken();

            if (newToken != null &&
                (currentToken == null || currentToken != newToken)) {
              await _authService.updateTokenFCM(userId, newToken);
            }
          } catch (e) {
            print('Error handling Firebase token: $e');
          }

          // Guardar información del usuario
          if (tipoUser == 'DEPARTAMENTO' || tipoUser == 'PRECEPTOR') {
            await AuthUtils.saveIdDormitorio(result['user']['Dormitorio']);
          }
          await AuthUtils.saveTipoUser(tipoUser);

          // Obtener datos del usuario y guardarlos
          final registerService = RegisterService();
          final userData = await registerService.getDatosUser(newUserId);
          await saveUserInfo(userData);

          // Verificar si el usuario está activo
          if (result['user']['StatusActividad'] == 1) {
            // Redirigir según el tipo de usuario
            _navigateToUserHome(tipoUser);
          } else {
            _showSnackbar('Usuario no activo');
          }
        } else {
          _showSnackbar('Credenciales inválidas');
        }
      } catch (error) {
        if (mounted) {
          Navigator.pop(context);
        }
        _showSnackbar('Error de autenticación');
      }
    }
  }

  void _navigateToUserHome(String tipoUser) {
    final Map<String, String> routes = {
      'ALUMNO': '/homeStudentMenu',
      'PRECEPTOR': '/homePreceptorMenu',
      'DEPARTAMENTO': '/homeDepartamentMenu',
      'EMPLEADO': '/homeEmployeeMenu',
      'VIGILANCIA': '/homeEmployeeMenu',
    };

    String? route = routes[tipoUser];

    if (route != null) {
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    } else {
      _showSnackbar('Tipo de usuario no reconocido');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Container(
      constraints: BoxConstraints(
        maxWidth: responsive.IsTablet ? 480 : 360,
      ),
      child: Form(
        key: _formKey,
        child: Card(
          color: const Color.fromRGBO(189, 188, 188, 1),
          elevation: 8.0, // Ajusta la sombra de la tarjeta
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          margin: EdgeInsets.symmetric(vertical: responsive.hp(2)),
          child: Padding(
            padding: EdgeInsets.all(responsive.wp(5)),
            child: Column(
              children: [
                TextFieldWidget(
                  label: 'Matrícula',
                  onChanged: (text) {
                    _usernameOrEmail =
                        text; // Guardar el valor de la matrícula o correo
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'El campo no puede estar vacío';
                    }
                    return null;
                  },
                ),
                SizedBox(height: responsive.hp(1)),
                TextFieldWidget(
                  label: "Contraseña",
                  obscureText: true,
                  onChanged: (text) {
                    _password = text; // Guardar el valor de la contraseña
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'El campo no puede estar vacío';
                    }
                    return null;
                  },
                ),
                SizedBox(height: responsive.hp(2)),
                SizedBox(
                  width: responsive.wp(60),
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(250, 198, 0, 1),
                      padding:
                          EdgeInsets.symmetric(vertical: responsive.hp(1.6)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(responsive.wp(10)),
                      ),
                    ),
                    child: Text(
                      'Ingresar',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: responsive.dp(2),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
