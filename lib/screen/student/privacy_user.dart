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
              color: const Color.fromRGBO(250, 198, 0, 1),
              fontSize: responsive.dp(2.2)),
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        Image.asset(
                          'assets/image/politica.png',
                          scale: 5,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Políticas de Privacidad',
                          style: TextStyle(
                            fontSize: responsive.hp(2.4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            child: Container(
              width: double.infinity,
              color: const Color.fromRGBO(6, 66, 106, 1),
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Revisión 2023 - 5 de mayo de 2023.',
                          style: TextStyle(
                            fontSize: responsive.hp(1.8),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'La Universidad Linda Vista, A. C., como responsable del uso de datos personales, pone a su disposición, de conformidad con la Ley Federal de Protección de Datos Personales en Posesión de los Particulares, el siguiente',
                          style: TextStyle(
                            fontSize: responsive.hp(2),
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: _launchUrl,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(250, 198, 0, 1),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Más información',
                        style: TextStyle(
                            color: Colors.black, fontSize: responsive.hp(1.8)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
      //bottomNavigationBar: BottomNavigationBar(
      //  items: const <BottomNavigationBarItem>[
      //    BottomNavigationBarItem(
      //      icon: Icon(Icons.home),
      //      label: 'Inicio',
      //    ),
      //    BottomNavigationBarItem(
      //      icon: Icon(Icons.list),
      //      label: 'Salidas',
      //    ),
      //    BottomNavigationBarItem(
      //      icon: Icon(Icons.person),
      //      label: 'Perfil',
      //    ),
      //  ],
      //),
    );
  }
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
