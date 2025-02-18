import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://ulv.edu.mx/privacidad');

class PrivacyUserScreen extends StatefulWidget {
  static const routeName = '/privacyUser';
  const PrivacyUserScreen({super.key});

  @override
  State<PrivacyUserScreen> createState() => _PrivacyUserScreenState();
}

class _PrivacyUserScreenState extends State<PrivacyUserScreen> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(5);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(6, 66, 106, 1),
        centerTitle: true,
        title: Text(
          'Políticas de Privacidad',
          style: TextStyle(
            color: Colors.white,
            fontSize: responsive.dp(2.2),
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromRGBO(250, 198, 0, 1)),
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
                  Image.asset(
                    'assets/image/politica.png',
                    scale: 5,
                  ),
                  SizedBox(height: responsive.hp(2)),
                  Text(
                    'Políticas de Privacidad',
                    style: TextStyle(
                      fontSize: responsive.dp(2.4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: responsive.hp(2)),
                  Text(
                    'La Universidad Linda Vista, A. C., como responsable del uso de datos personales, pone a su disposición, de conformidad con la Ley Federal de Protección de Datos Personales en Posesión de los Particulares, el siguiente:',
                    style: TextStyle(fontSize: responsive.dp(2)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.hp(1)),
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(responsive.dp(4)),
                topRight: Radius.circular(responsive.dp(4)),
              ),
              child: Container(
                width: double.infinity,
                color: const Color.fromRGBO(189, 188, 188, 1),
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: responsive.hp(12)),
                    Text(
                      'Revisión 2023 - 5 de mayo de 2023.',
                      style: TextStyle(
                        fontSize: responsive.dp(2),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsive.hp(2)),
                    Text(
                      'Consulta el documento completo de nuestras políticas de privacidad en el siguiente enlace.',
                      style: TextStyle(
                        fontSize: responsive.dp(2),
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsive.hp(4)),
                    ElevatedButton(
                      onPressed: _launchUrl,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(250, 198, 0, 1),
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(10),
                          vertical: responsive.hp(2),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(responsive.dp(2)),
                        ),
                      ),
                      child: Text(
                        'Más información',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: responsive.dp(2),
                        ),
                      ),
                    ),
                    SizedBox(height: responsive.hp(6)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
