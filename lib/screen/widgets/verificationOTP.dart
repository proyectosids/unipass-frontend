import 'package:flutter/material.dart';

class VerificationOTP extends StatelessWidget {
  final TextEditingController controller1;
  final TextEditingController controller2;
  final TextEditingController controller3;
  final TextEditingController controller4;

  const VerificationOTP({
    super.key,
    required this.controller1,
    required this.controller2,
    required this.controller3,
    required this.controller4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildVerificationBox(context, controller1),
        _buildVerificationBox(context, controller2),
        _buildVerificationBox(context, controller3),
        _buildVerificationBox(context, controller4),
      ],
    );
  }

  Widget _buildVerificationBox(
      BuildContext context, TextEditingController controller) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
