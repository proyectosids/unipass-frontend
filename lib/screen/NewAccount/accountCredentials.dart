import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/screen/widgets/text_input.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';

class NewAccountCredentials extends StatefulWidget {
  static const routeName = '/accountCredentials';
  const NewAccountCredentials({super.key});

  @override
  _NewAccountCredentialsState createState() => _NewAccountCredentialsState();
}

class _NewAccountCredentialsState extends State<NewAccountCredentials> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _matriculaController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _matriculaController
        .dispose(); // Asegúrate de disponer del controlador de matrícula
    super.dispose();
  }

  void _showSuccessDialog() {
    final Responsive responsive = Responsive.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive.wp(10)),
          ),
          child: Padding(
            padding: EdgeInsets.all(responsive.wp(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Notificación',
                  style: TextStyle(
                    fontSize: responsive.dp(2.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: responsive.hp(5)),
                Text(
                  'Se ha creado tu cuenta con éxito. Vaya al login para poder acceder',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: responsive.dp(1.8),
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: responsive.hp(5)),
                SizedBox(
                  width: responsive.wp(50),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login',
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(responsive.wp(30)),
                      ),
                    ),
                    child: Text(
                      'Ir al login',
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
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    final Responsive responsive = Responsive.of(context);
    return (await showDialog(
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
                    'Salir del proceso',
                    style: TextStyle(
                      fontSize: responsive.dp(2.8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: responsive.hp(5)),
                  Text(
                    '¿Estás seguro de que quieres salir del proceso de cambio de contraseña?',
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
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login',
                                (Route<dynamic> route) => false,
                              );
                            },
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
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(5);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height:
                            responsive.hp(5)), // Añadimos espacio al principio
                    Text(
                      'UniPass ULV',
                      style: TextStyle(
                        fontSize: responsive.dp(3),
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: responsive.hp(2)),
                    Text(
                      'Crear cuenta',
                      style: TextStyle(
                        fontSize: responsive.dp(2.6),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: responsive.hp(2)),
                    Text(
                      'Utilizaremos tu matrícula como usuario',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: responsive.dp(2.2),
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: responsive.hp(4)),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: responsive.IsTablet ? 480 : 360,
                      ),
                      child: TextFieldWidget(
                        controller: _matriculaController,
                        label: 'Ingresa tu matrícula',
                        keyboardType: TextInputType.number,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'El campo no puede estar vacío';
                          }
                          final int? number = int.tryParse(text);
                          if (number == null) {
                            return 'El campo debe ser tu matricula';
                          }
                          if (number < 200000 || number > 300000) {
                            return 'El número debe ser una matricula real';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: responsive.IsTablet ? 480 : 360,
                      ),
                      child: TextFieldWidget(
                        controller: _passwordController,
                        label: 'Nueva Contraseña',
                        obscureText: true,
                        onChanged: (text) {
                          print("password: $text");
                        },
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'El campo no puede estar vacío';
                          }
                          if (!RegExp(
                                  r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,20}$')
                              .hasMatch(text)) {
                            return 'La contraseña debe tener entre 8 y 20 caracteres.\nDebe contener al menos una mayucula \nDebe contener al menos un numero';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: responsive.hp(2)),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: responsive.IsTablet ? 480 : 360,
                      ),
                      child: TextFieldWidget(
                        controller: _confirmPasswordController,
                        label: 'Repetir Contraseña',
                        obscureText: true,
                        onChanged: (text) {
                          print("confirm: $text");
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor repite la contraseña';
                          }
                          if (value != _passwordController.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: responsive.hp(10)),
                    SizedBox(
                      width: responsive.wp(60),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            // Acción al presionar el botón de guardar contraseña
                            _showSuccessDialog();
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
                          'Guardar contraseña',
                          style: TextStyle(
                            fontSize: responsive.hp(2),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: responsive.hp(2)), // Añadimos espacio al final
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
