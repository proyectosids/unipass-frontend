import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/models/users.dart';
import 'package:flutter_application_unipass/screen/new_account/verificacionAccount.dart';
import 'package:flutter_application_unipass/services/otp_service.dart';
import 'package:flutter_application_unipass/services/register_service.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:flutter_application_unipass/screen/widgets/input_authentication.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewAccountAuthentication extends StatefulWidget {
  static const routeName = '/accountAuthentication';
  const NewAccountAuthentication({Key? key}) : super(key: key);

  @override
  State<NewAccountAuthentication> createState() =>
      _NewAccountAuthenticationState();
}

class _NewAccountAuthenticationState extends State<NewAccountAuthentication> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  late final OtpServices _otpServices;
  late String cuentaEmail;
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _otpServices = OtpServices();
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

  // Convertir obtenerCorreo en una función asincrónica
  Future<String> obtenerCorreo(String matricula) async {
    final UserData userData = await RegisterService().getDatosUser(
        matricula); // Espera el resultado de la llamada asincrónica
    return userData.type == 'ALUMNO'
        ? userData.students?.first.correoInstitucional ?? 'Correo no disponible'
        : userData.employees?.first.emailInstitucional ??
            'Correo no disponible';
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _hideLoadingDialog() {
    Navigator.of(context).pop();
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
                          'UniPass',
                          style: TextStyle(
                              fontSize: responsive.dp(3),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              color: Colors.black),
                        ),
                        SizedBox(height: responsive.dp(3)),
                        Text(
                          'Crear una cuenta',
                          style: TextStyle(
                            fontSize: responsive.dp(2.4),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: responsive.hp(3)),
                        SvgPicture.asset(
                          'assets/image/NewUser.svg',
                          height: imageHeight,
                          placeholderBuilder: (BuildContext context) =>
                              const CircularProgressIndicator(),
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
                                  // Mostrar el indicador de carga
                                  _showLoadingDialog();

                                  await _otpServices
                                      .loginOTP(); // Ahora el servicio está accesible aquí

                                  // Llamar a obtenerCorreo de forma asincrónica
                                  cuentaEmail = await obtenerCorreo(
                                      _emailController.text);

                                  await _otpServices.launchOTP(cuentaEmail);
                                  print("OTP enviado con éxito");

                                  // Ocultar el indicador de carga antes de navegar
                                  _hideLoadingDialog();

                                  Navigator.pushNamed(
                                      context, VerificationNewAccount.routeName,
                                      arguments: {
                                        'emailController':
                                            _emailController.text,
                                        'cuentaEmail': cuentaEmail,
                                      });
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
                          'CONTINUAR',
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
                      'Ya tengo una cuenta',
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
