import 'package:flutter_application_unipass/utils/imports.dart';

class Preview1 extends StatelessWidget {
  static const routeName = '/preview1';
  const Preview1({super.key});

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
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: responsive.hp(3)),
                    SvgPicture.asset(
                      'assets/image/presentacion-1.svg',
                      height: imageHeight,
                    ),
                  ],
                ),
                SizedBox(height: responsive.hp(2)),
                Column(
                  children: [
                    Text(
                      '¿Qué es eso?',
                      style: TextStyle(
                        fontSize: responsive.dp(3),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: responsive.hp(1)),
                    Text(
                      'Es una aplicación destinada para las salidas de los estudiantes y personal de la Universidad Linda Vista',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: responsive.dp(2.4),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.hp(10)),
                SizedBox(
                  width: responsive.wp(60),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const Preview2(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = const Offset(1.0, 0.0);
                            var end = Offset.zero;
                            var curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(250, 198, 0, 1),
                      padding: EdgeInsets.symmetric(
                        vertical: responsive.hp(2),
                      ),
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
