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

  void _submit() {
    final isOk = _formKey.currentState?.validate() ?? false;
    if (isOk) {
      // Lógica para cuando la validación es exitosa
      Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) =>
              false); // Redirige a la pantalla principal y borra el historial
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
                print("user: $text");
              },
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'El campo no puede estar vacío';
                }
                final int? number = int.tryParse(text);
                if (number == null) {
                  return 'El campo debe ser tu matricula';
                }
                if (number < 200000 || number > 300000) {
                  return 'El número debe ser una matricula real';
                }
                return null;
              },
            ),
            SizedBox(height: responsive.hp(1)),
            TextFieldWidget(
              label: "Contraseña",
              obscureText: true,
              onChanged: (text) {
                print("password: $text");
              },
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'El campo no puede estar vacío';
                }
                if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,20}$')
                    .hasMatch(text)) {
                  return 'La contraseña es incorrecta';
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
