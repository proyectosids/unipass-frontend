import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/models/users.dart';

import 'package:flutter_application_unipass/screen/widgets/input_authentication.dart';
import 'package:flutter_application_unipass/services/auth_service.dart';
import 'package:flutter_application_unipass/services/otp_service.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthenticationPassword extends StatefulWidget {
  static const routeName = '/mailAuthentication';
  const AuthenticationPassword({super.key});

  @override
  State<AuthenticationPassword> createState() => _AuthenticationPasswordState();
}

class _AuthenticationPasswordState extends State<AuthenticationPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final OtpServices _otpServices = OtpServices();
  final AuthServices _authService = AuthServices();
  String? userId; // Modificado a String? para evitar problemas con late
  String? email; // Modificado a String? para evitar problemas con late
  late Future<UserData?> futureUserData;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(5);
    final double imageHeight = responsive.hp(30);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: responsive.hp(5)),
                    Column(
                      children: [
                        Text(
                          'UniPass',
                          style: TextStyle(
                              fontSize: responsive.dp(3),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              color: Colors.black),
                        ),
                        SizedBox(height: responsive.dp(3)),
                        Text(
                          'Recuperar Contraseña',
                          style: TextStyle(
                            fontSize: responsive.dp(2.4),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: responsive.hp(3)),
                        SvgPicture.asset(
                          'assets/image/Recuperar.svg',
                          height: imageHeight,
                        ),
                        SizedBox(height: responsive.hp(3)),
                        InputAuthentication(
                            responsive: responsive,
                            emailController: _emailController),
                      ],
                    ),
                    SizedBox(height: responsive.hp(3)),
                    SizedBox(
                      width: responsive.wp(60),
                      child: ElevatedButton(
                        onPressed: _emailController.text.isEmpty
                            ? null
                            : () async {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  // Usa el correo ingresado manualmente
                                  userId = _emailController.text;
                                  try {
                                    Map<String, dynamic>? userData =
                                        await _authService
                                            .getinfoMatricula(userId!);
                                    if (userData == null) {
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Usuario no encontrado')));
                                      return;
                                    }

                                    email = userData['Correo'];

                                    // Realiza la autenticación de OTP
                                    try {
                                      await _otpServices.loginOTP();
                                      await _otpServices.forgotOTP(email!);
                                      await Navigator.pushReplacementNamed(
                                        context,
                                        '/verificationPassword',
                                        arguments: email,
                                      );
                                    } catch (error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Error enviando OTP: $error')));
                                    }
                                  } catch (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Error recuperando usuario: $error')));
                                  }
                                }
                              },
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
                          'Continuar',
                          style: TextStyle(
                            fontSize: responsive.dp(2),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: responsive.hp(2)),
                    Text(
                      'Si recuerdo mi contraseña',
                      style: TextStyle(
                        fontSize: responsive.dp(1.8),
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: responsive.hp(2)),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (route) => false);
                      },
                      child: Text(
                        'Regresar',
                        style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'Roboto',
                          fontSize: responsive.dp(1.8),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(height: responsive.hp(2)),
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
