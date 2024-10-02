import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/screen/widgets/text_input.dart';
import 'package:flutter_application_unipass/services/auth_service.dart';
import 'package:flutter_application_unipass/services/otp_service.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';

class CreateNewPassword extends StatefulWidget {
  static const routeName = '/newPassword';
  const CreateNewPassword({super.key});

  @override
  _CreateNewPasswordState createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final OtpServices _otpServices = OtpServices(); // Servicio OTP
  final AuthServices _authServices =
      AuthServices(); // Servicio de autenticación

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                  'Contraseña restablecida. Ve al login para iniciar sesión',
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
                      backgroundColor: const Color.fromRGBO(250, 198, 0, 1),
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

  Future<void> _resetPassword(
      String email, String otpCode, String newPassword) async {
    try {
      // Llamamos al método resetPassword del servicio OTP
      bool? isValid =
          await _otpServices.resetPassword(email, otpCode, newPassword);

      if (isValid == false) {
        // Si la verificación del OTP es incorrecta, regresar a la pantalla anterior con Navigator.pop()
        Navigator.pop(context); // Realiza un pop al stack de navegación
        return; // Detener la ejecución si el OTP es inválido
      }

      // Si el OTP es válido, intentamos actualizar la contraseña
      bool isPasswordUpdated = await _authServices.updatePassword(
          email, newPassword); // Llamamos al servicio de autenticación

      if (isPasswordUpdated) {
        // Si la contraseña fue actualizada, mostrar un diálogo de éxito
        _showSuccessDialog();
      } else {
        throw Exception('No se pudo actualizar la contraseña');
      }
    } catch (error) {
      // Manejamos errores mostrando un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al restablecer la contraseña: $error')),
      );
    }
  }

  Future<bool> _onWillPop() async {
    final Responsive responsive = Responsive.of(context);
    return (await showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.white,
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
                              backgroundColor:
                                  const Color.fromRGBO(250, 198, 0, 1),
                              padding: EdgeInsets.symmetric(
                                  vertical: responsive.hp(1.6)),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(responsive.wp(10)),
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
    final Map<String, String> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final String email = args['email']!;
    final String otpCode = args['otpCode']!;

    print('Correo: $email');
    print('OTP: $otpCode');
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
                      'UniPass',
                      style: TextStyle(
                        fontSize: responsive.dp(3),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: responsive.hp(2)),
                    Text(
                      'Cambiar contraseña',
                      style: TextStyle(
                        fontSize: responsive.dp(2.6),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: responsive.hp(2)),
                    Text(
                      'Crea una nueva contraseña para que puedas ingresar a tu cuenta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: responsive.dp(2.2),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: responsive.hp(4)),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa una contraseña';
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
                            // Llamar al servicio resetPassword cuando las contraseñas sean válidas
                            _resetPassword(
                                email, otpCode, _passwordController.text);
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
                          'Guardar contraseña',
                          style: TextStyle(
                            fontSize: responsive.hp(2),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
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
