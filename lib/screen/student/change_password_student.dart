import 'package:flutter_application_unipass/utils/imports.dart';

class ChangepasswordStudent extends StatefulWidget {
  static const routeName = '/changeStudent';
  const ChangepasswordStudent({super.key});

  @override
  State<ChangepasswordStudent> createState() => _ChangepasswordStudentState();
}

class _ChangepasswordStudentState extends State<ChangepasswordStudent> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
        child: Column(
          children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: responsive.hp(2)),
                  Text(
                    '¿Necesitas más seguridad?',
                    style: TextStyle(
                      fontSize: responsive.dp(3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: responsive.hp(2)),
                  Text(
                    'Si has ingresado tu cuenta en otro dispositivo y crees que puede estar comprometida, te recomendamos cambiar la contraseña',
                    style: TextStyle(fontSize: responsive.dp(2)),
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.hp(2)),
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(responsive.dp(5)),
                topRight: Radius.circular(responsive.dp(5)),
              ),
              child: Container(
                width: double.infinity,
                color: const Color.fromRGBO(189, 188, 188, 1),
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: responsive.hp(5)),
                    TextFieldWidget(
                      controller: _currentPasswordController,
                      label: 'Contraseña actual',
                      obscureText: true,
                    ),
                    SizedBox(height: responsive.hp(5)),
                    TextFieldWidget(
                      controller: _newPasswordController,
                      label: 'Nueva contraseña',
                      obscureText: true,
                    ),
                    SizedBox(height: responsive.hp(5)),
                    TextFieldWidget(
                      controller: _confirmPasswordController,
                      label: 'Repetir contraseña',
                      obscureText: true,
                    ),
                    SizedBox(height: responsive.hp(10)),
                    Center(
                      child: ElevatedButton(
                        onPressed: _changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(250, 198, 0, 1),
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(10),
                            vertical: responsive.hp(2),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(responsive.dp(2)),
                          ),
                        ),
                        child: Text(
                          'Guardar contraseña',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: responsive.dp(2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: responsive.hp(10)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword() {
    // Lógica para cambiar la contraseña
  }
}
