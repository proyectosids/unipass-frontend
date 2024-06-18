import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:flutter_application_unipass/screen/widgets/textInput.dart';

class LoginTextFields extends StatefulWidget {
  const LoginTextFields({super.key});

  @override
  State<LoginTextFields> createState() => _LoginTextFieldsState();
}

class _LoginTextFieldsState extends State<LoginTextFields> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _username = '';

  void _submit() {
    final isOk = _formKey.currentState?.validate() ?? false;
    if (isOk) {
      // Validar el tipo de usuario y redirigir a la pantalla correspondiente
      if (_username == '221068') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/homeStudentMenu',
          (route) => false,
        );
      } else if (_username == 'EMP2024') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/homePreceptorMenu',
          (route) => false,
        );
      } else {
        // Manejar otros tipos de usuario o mostrar un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario no reconocido')),
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
              label: 'Matricula',
              onChanged: (text) {
                _username = text; // Guardar el valor del usuario
              },
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'El campo no puede estar vacío';
                }
                // La lógica de validación de la matrícula depende de tus requisitos específicos.
                return null;
              },
            ),
            SizedBox(height: responsive.hp(1)),
            TextFieldWidget(
              label: "Contraseña",
              obscureText: true,
              onChanged: (text) {
                // Puedes guardar la contraseña si es necesario para la autenticación.
              },
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'El campo no puede estar vacío';
                }
                // Puedes añadir más lógica de validación para la contraseña aquí.
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
