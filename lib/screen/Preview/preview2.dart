import 'package:flutter_application_unipass/utils/imports.dart';

class Preview2 extends StatelessWidget {
  static const routeName = '/preview2';
  const Preview2({super.key});

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: responsive.hp(2)),
              Column(
                children: [
                  Text(
                    'UniPass ULV',
                    style: TextStyle(
                      fontSize: responsive.dp(3),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: responsive.hp(5)),
                  SvgPicture.asset(
                    'assets/image/presentation-2.svg',
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
                      fontSize: responsive.dp(2.4),
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: responsive.hp(4)),
                  Text(
                    '¿Estás listo para esto?',
                    style: TextStyle(
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const LoginApp(), // Ajusta esto a la ruta correcta
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
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(responsive.wp(10)),
                    ),
                  ),
                  child: Text(
                    'CONTINUAR',
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
    );
  }
}
