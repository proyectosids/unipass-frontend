import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/screen/widgets/text_input.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:flutter/services.dart'; // Importa esta librería para usar inputFormatters

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
        label: 'Número Matrícula',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingresa tu matrícula';
          }

          return null;
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // Solo permite dígitos
          LengthLimitingTextInputFormatter(
              10), // Limita la longitud a 10 caracteres
        ],
        keyboardType: TextInputType.number, // Muestra el teclado numérico
      ),
    );
  }
}
