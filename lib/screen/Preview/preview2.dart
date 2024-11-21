import 'package:flutter_application_unipass/utils/imports.dart';

class Preview2 extends StatelessWidget {
  static const routeName = '/preview2';
  const Preview2({super.key});

  Future<void> _setFirstTimeFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(5);
    final double imageHeight = responsive.hp(30);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: responsive.hp(2)),
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
                    SizedBox(height: responsive.hp(5)),
                    SvgPicture.asset(
                      'assets/image/presentacion-2.svg',
                      height: imageHeight,
                    ),
                  ],
                ),
                SizedBox(height: responsive.hp(2)),
                Column(
                  children: [
                    Text(
                      '¿Cómo lo haremos?',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: responsive.dp(3),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: responsive.wp(1.5)),
                    Text(
                      'Mediante una herramienta que la gran mayoría tenemos que es un dispositivo móvil o la web',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: responsive.dp(2.4),
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: responsive.hp(4)),
                    Text(
                      '¿Estás listo para esto?',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: responsive.dp(2.6),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.hp(4)),
                SizedBox(
                  width: responsive.wp(60),
                  child: ElevatedButton(
                    onPressed: () async {
                      await _setFirstTimeFlag();
                      Navigator.pushNamedAndRemoveUntil(
                        // ignore: use_build_context_synchronously
                        context,
                        LoginApp.routeName, // Ajusta esto a la ruta correcta
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(250, 198, 0, 1),
                      padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(responsive.wp(10)),
                      ),
                    ),
                    child: Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: responsive.dp(2),
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
    );
  }
}
