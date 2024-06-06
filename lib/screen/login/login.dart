import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/screen/widgets/loginForm.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';

class LoginApp extends StatefulWidget {
  static const routeName = '/login';
  const LoginApp({super.key});

  @override
  State<LoginApp> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(5); // 5% del ancho de la pantalla
    final double imageHeight = responsive.hp(20);

    return Scaffold(
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
                  SizedBox(height: responsive.hp(5)),
                  Column(
                    children: [
                      Text(
                        'UniPass ULV',
                        style: TextStyle(
                          fontSize: responsive.dp(3),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: responsive.hp(2)),
                      Opacity(
                        opacity: 0.2,
                        child: Image.asset(
                          'assets/image/Logo_ULV.png',
                          height: imageHeight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.hp(2)), // Space between sections
                  Text(
                    'Sé bienvenido a tu app para apoyo institucional',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: responsive.dp(2),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: responsive.hp(3)),
                  LoginTextFields(),

                  SizedBox(height: responsive.hp(2)),
                  Text(
                    'Olvidaste tu contraseña',
                    style: TextStyle(
                      fontSize: responsive.dp(1.5),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: responsive.hp(2)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/mailAuthentication');
                    },
                    child: Text(
                      'Recuperar',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: responsive.dp(1.8),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.hp(2)),
                  Divider(
                    color: Colors.black,
                    height: responsive.hp(1),
                    thickness: responsive.hp(0.2),
                    indent: responsive.wp(5),
                    endIndent: responsive.wp(5),
                  ),
                  SizedBox(height: responsive.hp(2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Eres nuevo?',
                        style: TextStyle(
                          fontSize: responsive.dp(1.5),
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/accountAuthentication');
                        },
                        child: Text(
                          'Crear una cuenta',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: responsive.dp(1.8),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Added spacing at the bottom
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
