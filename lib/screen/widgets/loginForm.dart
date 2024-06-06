import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:flutter_application_unipass/screen/widgets/textInput.dart';

class LoginTextFields extends StatelessWidget {
  const LoginTextFields({super.key});

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Container(
      constraints: BoxConstraints(
        maxWidth: responsive.IsTablet ? 480 : 360,
      ),
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
              if (!RegExp(r'^\d{8,20}$').hasMatch(text)) {
                return 'El campo debe tener de 6 a 20 carcateres';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
