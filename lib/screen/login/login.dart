import 'package:flutter_application_unipass/utils/imports.dart';

class LoginApp extends StatefulWidget {
  static const routeName = '/login';
  const LoginApp({Key? key}) : super(key: key);

  @override
  State<LoginApp> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(5); // 5% del ancho de la pantalla
    final double imageHeight = responsive.hp(20);

    return WillPopScope(
      onWillPop: () async {
        // Mostrar un diálogo de confirmación antes de salir de la aplicación
        bool exit = await showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(responsive.wp(10)),
            ),
            child: Padding(
              padding: EdgeInsets.all(responsive.wp(5)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '¿Salir de la aplicación?',
                    style: TextStyle(
                      fontSize: responsive.dp(2.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: responsive.hp(5)),
                  Text(
                    '¿Estás seguro de que deseas salir de la aplicación?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: responsive.dp(1.8),
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: responsive.hp(5)),
                  SizedBox(
                    width: responsive.wp(80),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width:
                              responsive.wp(30), // Ancho del botón "Cancelar"
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding: EdgeInsets.symmetric(
                                  vertical: responsive.hp(1.6)),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(responsive.wp(30)),
                              ),
                            ),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                fontSize: responsive.dp(2),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: responsive.wp(30), // Ancho del botón "Salir"
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(
                                  vertical: responsive.hp(1.6)),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(responsive.wp(30)),
                              ),
                            ),
                            child: Text(
                              'Salir',
                              style: TextStyle(
                                fontSize: responsive.dp(2),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Devolver true para salir de la aplicación si el usuario confirmó, de lo contrario, false
        return exit;
      },
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
                    SizedBox(height: responsive.hp(5)),
                    Column(
                      children: [
                        Text(
                          'UniPass',
                          style: TextStyle(
                            fontSize: responsive.dp(3),
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: responsive.hp(2)),
                        Opacity(
                          opacity: 0.8,
                          child: Image.asset(
                            'assets/image/U Linda Vista LOGO-01.png',
                            height: imageHeight,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: responsive.hp(2)), // Space between sections
                    Text(
                      'Bienvenido a tu app de apoyo institucional',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: responsive.dp(2),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: responsive.hp(3)),
                    const LoginTextFields(), // Login form

                    SizedBox(height: responsive.hp(2)),
                    Text(
                      '¿Olvidaste tu contraseña?',
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
                          '¿Eres nuevo?',
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
      ),
    );
  }
}
