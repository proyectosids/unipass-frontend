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
      try {
        final result = await _authService.authenticateUser(
            _usernameOrEmail, _usernameOrEmail, _password);
        if (result['success']) {
          String tipoUser = result['user']['TipoUser'];
          String userId = result['user']['Matricula'];
          String newUserId = userId.replaceFirst('MTR', '');

          // Guardar idDormitorio en SharedPreferences
          if (tipoUser == 'DEPARTAMENTO') {
            await AuthUtils.saveIdDormitorio(result['user']['Dormitorio']);
          }

          // Guardar tipoUser en SharedPreferences
          await AuthUtils.saveTipoUser(tipoUser);

          // Llamar al servicio con la matrícula del usuario
          final registerService = RegisterService();
          final userData = await registerService.getDatosUser(newUserId);

          // Verificar si el usuario está activo
          if (result['user']['StatusActividad'] == 1) {
            // Guardar la información del usuario en SharedPreferences
            await saveUserInfo(userData);

            // Redirigir según el tipo de usuario
            if (tipoUser == 'ALUMNO') {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/homeStudentMenu', // Ruta para alumnos
                (route) => false,
              );
            } else if (tipoUser == 'PRECEPTOR') {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/homePreceptorMenu', // Ruta para preceptores
                (route) => false,
              );
            } else if (tipoUser == 'DEPARTAMENTO') {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/homeDepartamentMenu', // Ruta para preceptores
                (route) => false,
              );
            } else if (tipoUser == 'EMPLEADO' || tipoUser == 'VIGILANCIA') {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/homeEmployeeMenu', // Ruta para empleados o vigilancia
                (route) => false,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tipo de usuario no reconocido')),
              );
            }
          } else {
            // Si el usuario no está activo
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Usuario no activo')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Credenciales inválidas')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error de autenticación')),
        );
      }
    }
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
                  label: 'Matrícula o correo',
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
