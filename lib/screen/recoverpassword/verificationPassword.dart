import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/screen/widgets/verification_otp.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';

class VerificationPassword extends StatefulWidget {
  static const routeName = '/verificationPassword';
  const VerificationPassword({super.key});

  @override
  _VerificationPasswordState createState() => _VerificationPasswordState();
}

class _VerificationPasswordState extends State<VerificationPassword> {
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

  Future<bool> _onWillPop() async {
    Navigator.pushReplacementNamed(context, '/login');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Recibir el correo que fue pasado desde la pantalla anterior
    final String? email = ModalRoute.of(context)!.settings.arguments as String?;

    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(5); // 5% del ancho de la pantalla

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: responsive.hp(10)), // Espacio al principio
                    Column(
                      children: [
                        Text(
                          'UniPass',
                          style: TextStyle(
                              fontSize: responsive.dp(3),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(height: responsive.hp(2)),
                        Text(
                          'Se ha enviado un correo a',
                          style: TextStyle(
                            fontSize: responsive.dp(2.6),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          email!,
                          style: TextStyle(
                            fontSize: responsive.dp(2.6),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: responsive.hp(5)),
                        Text(
                          'Enviamos un mensaje al correo que proporcionaste para enviar la verificación.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: responsive.dp(2.2),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.hp(8)),
                    VerificationOTP(
                      controller1: _controller1,
                      controller2: _controller2,
                      controller3: _controller3,
                      controller4: _controller4,
                    ),
                    SizedBox(height: responsive.hp(12)),
                    SizedBox(
                      width: responsive.wp(60),
                      child: ElevatedButton(
                        onPressed: _isButtonEnabled
                            ? () {
                                // Concatenar los dígitos del OTP
                                final String otpCode = _controller1.text +
                                    _controller2.text +
                                    _controller3.text +
                                    _controller4.text;
                                print(email);
                                print(otpCode);
                                // Pasar el correo y el OTP concatenado a la pantalla siguiente
                                Navigator.pushNamed(
                                  context,
                                  '/newPassword',
                                  arguments: {
                                    'email': email,
                                    'otpCode': otpCode,
                                  },
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(250, 198, 0, 1),
                          padding: EdgeInsets.symmetric(
                              vertical: responsive.hp(1.6)),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(responsive.wp(10)),
                          ),
                        ),
                        child: Text(
                          'Verificar',
                          style: TextStyle(
                            fontSize: responsive.dp(2),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: responsive.hp(18)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
