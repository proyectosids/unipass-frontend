import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/screen/widgets/textInput.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';

class InputAuthentication extends StatelessWidget {
  const InputAuthentication({
    super.key,
    required this.responsive,
    required this.emailController,
  });

  final Responsive responsive;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: responsive.IsTablet ? 480 : 360,
      ),
      child: TextFieldWidget(
        controller: emailController,
        label: 'Correo Institucional o Matrícula',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingresa tu correo institucional o matrícula';
          }
          final int? number = int.tryParse(value);
          if (number != null) {
            // Validación para matrícula
            if (number < 200000 || number > 300000) {
              return 'Debe ser una matrícula real ';
            }
          } else {
            // Validación para correo institucional
            final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@ulv\.edu\.mx$');
            if (!emailRegex.hasMatch(value)) {
              return 'Por favor, ingresa un correo válido (@ulv.edu.mx)';
            }
          }
          return null;
        },
      ),
    );
  }
}
