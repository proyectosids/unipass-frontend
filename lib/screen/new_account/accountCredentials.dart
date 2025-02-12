import 'package:flutter_application_unipass/services/bedroom_service.dart';
import 'package:flutter_application_unipass/utils/imports.dart';
import 'package:flutter_application_unipass/services/register_service.dart';

class NewAccountCredentials extends StatefulWidget {
  static const routeName = '/accountCredentials';
  final Map<String, dynamic> userData;

  const NewAccountCredentials({Key? key, required this.userData})
      : super(key: key);

  @override
  _NewAccountCredentialsState createState() => _NewAccountCredentialsState();
}

class _NewAccountCredentialsState extends State<NewAccountCredentials> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? nivelAcademico;
  String? sexo;
  int dormitorio = 0;
  final BedroomService _bedroomService = BedroomService();
  bool _isLoading = false; // Variable para manejar la pantalla de carga

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
    //_loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nivelAcademico = prefs.getString('nivelAcademico');
    String? sexo = prefs.getString('sexo');

    if (nivelAcademico == null || sexo == null) {
      print('Nivel académico o sexo no encontrado en SharedPreferences');
    } else {
      print('Nivel académico: $nivelAcademico, Sexo: $sexo');
    }
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

  void _showSuccessDialog() {
    final Responsive responsive = Responsive.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
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

  String _validateString(dynamic value) {
    return (value == null || value.toString().isEmpty)
        ? 'N/A'
        : value.toString();
  }

  int _validateInt(dynamic value) {
    return (value == null || value.toString().isEmpty)
        ? 0
        : int.tryParse(value.toString()) ?? 0;
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true;
      });
      _showLoadingDialog(); // Mostrar pantalla de carga

      try {
        final registerService = RegisterService();
        List<int> dormitorios = [315, 316, 317, 318];
        String? tipoUsuario;
        int? dormitorio;

        for (var i = 0; i < 4; i++) {
          int? preceMatricula =
              await registerService.getPreceptor(dormitorios[i]);
          if (preceMatricula == widget.userData['matricula']) {
            tipoUsuario = 'PRECEPTOR';
            dormitorio = i + 1;
            break;
          }
        }

        bool? isjefeVigilancia = await registerService
            .getJefeVigilancia(widget.userData['matricula'].toString());
        if (isjefeVigilancia == true) {
          tipoUsuario = 'VIGILANCIA';
        }

        tipoUsuario ??= widget.userData['type'];

        String? nivelAcademico = widget.userData['nivelAcademico'];
        String? sexo = widget.userData['sexo'];

        if (tipoUsuario == 'ALUMNO') {
          dormitorio =
              await _bedroomService.obtenerDormitorio(nivelAcademico, sexo);
        } else if (tipoUsuario == 'EMPLEADO' ||
            //tipoUsuario == 'PRECEPTOR' ||
            tipoUsuario == 'VIGILANCIA') {
          dormitorio = 5;
        }

        dormitorio ??= 5;

        setState(() {
          // Aquí puedes actualizar el estado si necesitas usar el valor de dormitorio.
        });

        final userData = {
          'Matricula': _validateString(widget.userData['matricula']),
          'Contraseña': _passwordController.text,
          'Correo': _validateString(widget.userData['correoInstitucional']),
          'Nombre': _validateString(widget.userData['nombres']),
          'Apellidos': _validateString(widget.userData['apellidos']),
          'TipoUser': _validateString(tipoUsuario),
          'Sexo': _validateString(widget.userData['sexo']),
          'FechaNacimiento':
              _validateString(widget.userData['fechaNacimiento']),
          'Celular': _validateString(widget.userData['celular']),
          'Dormitorio': dormitorio,
        };
        await registerService.registerUser(userData);

        _hideLoadingDialog(); // Ocultar pantalla de carga
        _showSuccessDialog(); // Mostrar diálogo de éxito
      } catch (e) {
        _hideLoadingDialog(); // Ocultar pantalla de carga en caso de error
        String errorMessage = 'Error: $e';
        if (e.toString().contains('Usuario ya registrado')) {
          errorMessage = 'El usuario ya está registrado';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                    '¿Estás seguro de que quieres salir del proceso de crear cuenta?',
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

    // Recuperar los argumentos pasados desde la pantalla anterior
    final userData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

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
                    SizedBox(height: responsive.hp(5)),
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
                      'Crear cuenta',
                      style: TextStyle(
                        fontSize: responsive.dp(2.6),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: responsive.hp(2)),
                    Text(
                      'Utilizaremos tu matrícula como usuario',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: responsive.dp(2.2),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: responsive.hp(4)),
                    Text(
                      'Usuario: ${userData['matricula']}',
                      style: TextStyle(
                          fontSize: responsive.dp(2.2),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                          color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 20),
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
                        onPressed: _registerUser,
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
                          'Registrar cuenta',
                          style: TextStyle(
                            fontSize: responsive.hp(2),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
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
