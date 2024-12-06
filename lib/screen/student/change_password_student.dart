import 'package:flutter_application_unipass/services/auth_service.dart';
import 'package:flutter_application_unipass/services/otp_service.dart';
import 'package:flutter_application_unipass/utils/imports.dart';

class ChangepasswordStudent extends StatefulWidget {
  static const routeName = '/changeStudent';
  const ChangepasswordStudent({super.key});

  @override
  State<ChangepasswordStudent> createState() => _ChangepasswordStudentState();
}

class _ChangepasswordStudentState extends State<ChangepasswordStudent> {
  final OtpServices _otpServices = OtpServices();
  final AuthServices _authService = AuthServices();

  String? matricula; // Variable para almacenar la matrícula
  String? correo; // Variable para almacenar el correo

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Cargar datos de SharedPreferences
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      matricula = prefs.getString('matricula'); // Obtiene la matrícula
      correo = prefs.getString('correo'); // Obtiene el correo
    });
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(5);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(6, 66, 106, 1),
        centerTitle: true,
        title: Text(
          'Cambiar contraseña',
          style: TextStyle(
              color: Colors.white,
              fontSize: responsive.dp(2.2),
              fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(250, 198, 0, 1),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // Contenido superior
              Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: responsive.hp(1)),
                    Text(
                      '¿Necesitas más seguridad?',
                      style: TextStyle(
                        fontSize: responsive.dp(3),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: responsive.hp(1)),
                    Text(
                      'Si has ingresado tu cuenta en otro dispositivo y crees que puede estar comprometida, te recomendamos cambiar la contraseña',
                      style: TextStyle(fontSize: responsive.dp(2)),
                    ),
                    SizedBox(height: responsive.hp(2)),
                    // Muestra matrícula y correo
                    if (matricula != null && correo != null) ...[
                      Text(
                        'Matrícula: $matricula',
                        style: TextStyle(fontSize: responsive.dp(2)),
                      ),
                      SizedBox(height: responsive.hp(1)),
                      Text(
                        'Correo: $correo',
                        style: TextStyle(fontSize: responsive.dp(2)),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: responsive.hp(10)),
              // Contenedor gris (sin espacio entre el texto y este contenedor)
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(responsive.dp(5)),
                    topRight: Radius.circular(responsive.dp(5)),
                  ),
                  child: Container(
                    width: double.infinity,
                    color: const Color.fromRGBO(189, 188, 188, 1),
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'A continuación se iniciará el proceso de cambio de contraseña.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: responsive.dp(2.5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                            height: responsive
                                .hp(3)), // Espacio entre el texto y el botón
                        SizedBox(
                          width: responsive.wp(60),
                          child: ElevatedButton(
                            onPressed: (matricula == null || correo == null)
                                ? null // Desactiva el botón si los datos no están cargados
                                : () async {
                                    try {
                                      // Obtén los datos de usuario usando la matrícula
                                      Map<String, dynamic>? userData =
                                          await _authService
                                              .getinfoMatricula(matricula!);
                                      if (userData == null ||
                                          userData['Correo'] == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Usuario no encontrado')),
                                        );
                                        return;
                                      }

                                      String email = userData['Correo'];

                                      // Realiza la autenticación de OTP
                                      try {
                                        await _otpServices.loginOTP();
                                        await _otpServices.forgotOTP(email);
                                        await Navigator.pushReplacementNamed(
                                          context,
                                          '/verificationPassword',
                                          arguments: email,
                                        );
                                      } catch (error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Error enviando OTP: $error')),
                                        );
                                      }
                                    } catch (error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Error recuperando usuario: $error')),
                                      );
                                    }
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changePassword() {
    // Lógica para cambiar la contraseña
  }
}
