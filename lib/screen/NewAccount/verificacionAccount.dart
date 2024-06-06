import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/screen/widgets/verificationOTP.dart';

class VerificationNewAccount extends StatefulWidget {
  static const routeName = '/verificationAccount';
  const VerificationNewAccount({super.key});

  @override
  _VerificationNewAccountState createState() => _VerificationNewAccountState();
}

class _VerificationNewAccountState extends State<VerificationNewAccount> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  bool get _isButtonEnabled {
    return _controller1.text.isNotEmpty &&
        _controller2.text.isNotEmpty &&
        _controller3.text.isNotEmpty &&
        _controller4.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _controller1.addListener(_updateState);
    _controller2.addListener(_updateState);
    _controller3.addListener(_updateState);
    _controller4.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller1.removeListener(_updateState);
    _controller2.removeListener(_updateState);
    _controller3.removeListener(_updateState);
    _controller4.removeListener(_updateState);
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
                SizedBox(height: 50), // Espacio al principio
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
                      'Enviamos un mensaje al correo que proporcionaste un código para crear tu cuenta.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 110),
                VerificationOTP(
                  controller1: _controller1,
                  controller2: _controller2,
                  controller3: _controller3,
                  controller4: _controller4,
                ),
                SizedBox(height: 100),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled
                        ? () {
                            Navigator.pushNamed(context, '/accountCredentials');
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
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
