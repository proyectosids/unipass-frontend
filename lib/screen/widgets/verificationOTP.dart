import 'package:flutter/material.dart';

class VerificationOTP extends StatefulWidget {
  final TextEditingController controller1;
  final TextEditingController controller2;
  final TextEditingController controller3;
  final TextEditingController controller4;

  const VerificationOTP({
    Key? key,
    required this.controller1,
    required this.controller2,
    required this.controller3,
    required this.controller4,
  }) : super(key: key);

  @override
  _VerificationOTPState createState() => _VerificationOTPState();
}

class _VerificationOTPState extends State<VerificationOTP> {
  @override
  void initState() {
    super.initState();
    widget.controller1.addListener(_updateButtonState);
    widget.controller2.addListener(_updateButtonState);
    widget.controller3.addListener(_updateButtonState);
    widget.controller4.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller1.removeListener(_updateButtonState);
    widget.controller2.removeListener(_updateButtonState);
    widget.controller3.removeListener(_updateButtonState);
    widget.controller4.removeListener(_updateButtonState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCodeInputField(widget.controller1),
        _buildCodeInputField(widget.controller2),
        _buildCodeInputField(widget.controller3),
        _buildCodeInputField(widget.controller4),
      ],
    );
  }

  Widget _buildCodeInputField(TextEditingController controller) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          counterText: '', // Aquí deshabilitamos el contador de caracteres
        ),
        maxLength: 1,
      ),
    );
  }
}
