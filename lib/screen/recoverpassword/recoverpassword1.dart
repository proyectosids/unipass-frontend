import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecoverPassword1 extends StatefulWidget {
  const RecoverPassword1({super.key});

  @override
  State<RecoverPassword1> createState() => _RecoverPassword1State();
}

class _RecoverPassword1State extends State<RecoverPassword1> {
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
    // Obtener el tamaño de la pantalla
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Definir estilos y tamaños responsivos
                  double textFontSize = screenSize.width < 600 ? 16 : 20;
                  double titleFontSize = screenSize.width < 600 ? 24 : 28;
                  double spacing = screenSize.width < 600 ? 20 : 40;
                  double buttonPadding = screenSize.width < 600 ? 15 : 20;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: spacing), // Añadimos espacio al principio
                      Column(
                        children: [
                          Text(
                            'UniPass ULV',
                            style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          SizedBox(height: spacing / 2),
                          Text(
                            'Recuperar Contraseña',
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: spacing),
                          SvgPicture.asset(
                            'assets/image/Recuperar.svg',
                            height: screenSize.width < 600 ? 200 : 300,
                          ),
                          SizedBox(height: spacing),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Correo Institucional'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu correo institucional';
                              }
                              if (!value.endsWith('@ulv.edu.mx')) {
                                return 'Por favor, ingresa un correo institucional válido (@ulv.edu.mx)';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: spacing),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _emailController.text.isEmpty
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    Navigator.pushNamed(context, "/Recover2");
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding:
                                EdgeInsets.symmetric(vertical: buttonPadding),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'CONTINUAR',
                            style: TextStyle(
                              fontSize: textFontSize,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: spacing),
                      Text(
                        'Si recuerdo mi contraseña',
                        style: TextStyle(
                          fontSize: textFontSize,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: spacing / 2),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/login");
                        },
                        child: Text(
                          'Regresar',
                          style: TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(height: spacing),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
