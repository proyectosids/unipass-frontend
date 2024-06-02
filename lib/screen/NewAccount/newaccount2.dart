import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/screen/widgets/verificationOTP.dart';

class NewAccount2 extends StatefulWidget {
  const NewAccount2({super.key});

  @override
  _NewAccount2State createState() => _NewAccount2State();
}

class _NewAccount2State extends State<NewAccount2> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  bool _isButtonEnabled = false;

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _controller1.text.isNotEmpty &&
          _controller2.text.isNotEmpty &&
          _controller3.text.isNotEmpty &&
          _controller4.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller1.addListener(_updateButtonState);
    _controller2.addListener(_updateButtonState);
    _controller3.addListener(_updateButtonState);
    _controller4.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Column(
                  children: [
                    Text(
                      'UniPass ULV',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Se ha enviado un correo',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 90),
                    Text(
                      'Enviamos un mensaje al correo que proporcionaste para enviar la verificación.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Spacer(),
                VerificationOTP(
                  controller1: _controller1,
                  controller2: _controller2,
                  controller3: _controller3,
                  controller4: _controller4,
                ),
                SizedBox(height: 30),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled
                        ? () {
                            // Acción al presionar el botón de Verificar
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Verificar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 150),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
