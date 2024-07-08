import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/services/auth_service.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:flutter_application_unipass/screen/widgets/text_input.dart';

class LoginTextFields extends StatefulWidget {
  const LoginTextFields({super.key});

  @override
  State<LoginTextFields> createState() => _LoginTextFieldsState();
}

class _LoginTextFieldsState extends State<LoginTextFields> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _usernameOrEmail = '';
  String _password = '';

  void _submit() async {
    final isOk = _formKey.currentState?.validate() ?? false;
    if (isOk) {
      try {
        final result = await authenticateUser(
            _usernameOrEmail, _usernameOrEmail, _password);
        if (result['success']) {
          String tipoUser = result['user']['TipoUser'];
          // Redirigir según el tipo de usuario
          if (tipoUser == 'Alumno') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/homeStudentMenu', // Ruta para alumnos
              (route) => false,
            );
          } else if (tipoUser == 'Preceptor') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/homePreceptorMenu', // Ruta para preceptores
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tipo de usuario no reconocido')),
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
        child: Column(
          children: [
            TextFieldWidget(
              label: 'Matricula o Correo',
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
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: responsive.hp(1.6)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(responsive.wp(10)),
                  ),
                ),
                child: Text(
                  'Ingresar',
                  style: TextStyle(
                    fontSize: responsive.dp(2),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
