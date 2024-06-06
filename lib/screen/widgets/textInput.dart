import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';

class TextFieldWidget extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final void Function(String text)? onChanged;
  final String? Function(String? text)? validator; // Hacemos validator nullable

  const TextFieldWidget({
    Key? key,
    this.label = '',
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return TextFormField(
      keyboardType: this.keyboardType,
      obscureText: this.obscureText,
      onChanged: this.onChanged,
      validator: this.validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: this.label,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: responsive.dp(1.5),
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
