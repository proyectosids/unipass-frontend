import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Preview1 extends StatelessWidget {
  static const routeName = '/preview1';
  const Preview1({super.key});

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(5);
    final double imageHeight = responsive.hp(30);

    return Scaffold(
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
                  SizedBox(height: responsive.hp(3)),
                  SvgPicture.asset(
                    'assets/image/presentation-1.svg',
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
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: responsive.hp(1)),
                  Text(
                    'Es una aplicación destinada para las salidas de los estudiantes internos de la Universidad Linda Vista',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: responsive.dp(2.4),
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.hp(10)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/preview2');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(
                      vertical: responsive.hp(2),
                    ),
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
