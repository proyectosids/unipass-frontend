import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Asegúrate de importar esto para los inputFormatters
import 'package:flutter_application_unipass/utils/responsive.dart';

class TextFieldWidget extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final void Function(String text)? onChanged;
  final String? Function(String? text)? validator;
  final TextEditingController? controller;
  final List<TextInputFormatter>?
      inputFormatters; // Parámetro opcional para inputFormatters

  const TextFieldWidget({
    Key? key,
    this.label = '',
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.controller,
    this.inputFormatters, // Inicializa el parámetro
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      inputFormatters:
          inputFormatters, // Pasa los inputFormatters al TextFormField
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromARGB(255, 255, 255, 255), // Fondo blanco
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.black, width: responsive.wp(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.black, // Borde cuando el campo no está seleccionado
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color.fromRGBO(250, 198, 0,
                1), // Cambia el color morado por azul (o el color que prefieras)
            width: 2.0, // Puedes ajustar el grosor
          ),
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontSize: responsive.dp(1.8),
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
