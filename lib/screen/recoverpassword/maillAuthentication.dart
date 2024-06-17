import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/screen/widgets/inputAuthentication.dart';
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
      backgroundColor: Colors.white,
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
                          'UniPass ULV',
                          style: TextStyle(
                              fontSize: responsive.dp(3),
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        SizedBox(height: responsive.dp(3)),
                        Text(
                          'Recuperar Contraseña',
                          style: TextStyle(
                            fontSize: responsive.dp(2.4),
                            fontWeight: FontWeight.bold,
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
                            : () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  Navigator.pushReplacementNamed(
                                      context, '/verificationPassword');
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(
                              vertical: responsive.hp(1.6)),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(responsive.wp(10)),
                          ),
                        ),
                        child: Text(
                          'CONTINUAR',
                          style: TextStyle(
                            fontSize: responsive.dp(2),
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
