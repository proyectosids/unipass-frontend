import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/services/auth_service.dart';
import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
import 'package:flutter_application_unipass/utils/imports.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  static const routeName = '/menu';

  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool isComplete = false;
  bool hasIdCargoDelegado = false;
  final AuthServices _authService = AuthServices();

  @override
  void initState() {
    super.initState();
    _checkDocumentCompletion();
  }

  Future<bool> _fetchDocumentos() async {
    int? userId = await AuthUtils.getUserId();
    if (userId == null) {
      print('User ID not found');
      return false;
    }

    Map<String, dynamic>? userInfo = await _authService.getUserInfo(userId);
    if (userInfo == null) {
      print('User info not found');
      return false;
    }

    return userInfo['Documentacion'] == 1;
  }

  Future<void> _checkDocumentCompletion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool ineTutor = prefs.getBool('INE del Tutor_isUploaded') ?? false;
    bool reglamentoDormitorio =
        prefs.getBool('Reglamento dormitorio_isUploaded') ?? false;
    bool convenioSalidas =
        prefs.getBool('Convenio de salidas_isUploaded') ?? false;

    setState(() {
      isComplete = ineTutor && reglamentoDormitorio && convenioSalidas;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(3);

    return WillPopScope(
      onWillPop: () async => false, // ⛔ No permitir volver atrás
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // ⛔ Ocultar la flecha de regreso
          backgroundColor: Colors.white,
          title: Text(
            'Menu',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: responsive.dp(2.2),
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(padding),
          child: FutureBuilder<bool>(
            future: _fetchDocumentos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading data'));
              } else {
                hasIdCargoDelegado = snapshot.data ?? false;

                List<Widget> menuItems = [
                  _buildMenuItem(
                    context,
                    'Salidas',
                    'assets/image/salidas.svg',
                    '/ExitStudent',
                    Colors.white,
                    hasIdCargoDelegado,
                  ),
                  _buildMenuItem(
                    context,
                    'Ayuda',
                    'assets/image/HelpApp.svg',
                    '/helpUser',
                    Colors.white,
                    true,
                  ),
                  _buildMenuItem(
                    context,
                    'Documentos',
                    'assets/image/documents.svg',
                    '/documentStudent',
                    Colors.white,
                    true,
                  ),
                ];

                return Column(
                  children: [
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: menuItems,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String assetPath,
      String routeName, Color color, bool isEnabled) {
    final Responsive responsive = Responsive.of(context);
    return GestureDetector(
      onTap: () async {
        if (isEnabled) {
          final result = await Navigator.pushNamed(context, routeName);
          if (result != null && result == true) {
            setState(() {
              _checkDocumentCompletion(); // Revisar el estado de los documentos
            });
          }
        }
      },
      child: Card(
        color: color,
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(assetPath,
                width: responsive.wp(12), height: responsive.hp(12)),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: responsive.dp(1.6),
                fontWeight: FontWeight.bold,
                color: isEnabled
                    ? const Color.fromRGBO(6, 66, 106, 1)
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
