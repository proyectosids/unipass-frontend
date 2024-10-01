import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
import 'package:flutter_application_unipass/utils/imports.dart';

class MenuPreceptorScreen extends StatefulWidget {
  static const routeName = '/menupreceptor';
  const MenuPreceptorScreen({super.key});

  @override
  State<MenuPreceptorScreen> createState() => _MenuPreceptorScreenState();
}

class _MenuPreceptorScreenState extends State<MenuPreceptorScreen> {
  String? typeUser;

  @override
  void initState() {
    super.initState();
    _getTypeUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notificationsStudent');
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  _buildMenuItem(
                    context,
                    'Salidas',
                    'assets/image/salidas.svg',
                    '/AuthorizationPreceptor',
                    Colors.white,
                  ),
                  _buildMenuItem(
                    context,
                    'Ayuda',
                    'assets/image/HelpApp.svg',
                    '/helpUser',
                    Colors.white,
                  ),
                  _buildMenuItem(
                    context,
                    'Documentos',
                    'assets/image/documents.svg',
                    '/fileDocuments',
                    Colors.white,
                  ),
                  _buildMenuItem(context, 'Checks', 'assets/image/checks.svg',
                      '/NewProfileChecks', Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String assetPath,
      String routeName, Color color) {
    final Responsive responsive = Responsive.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Card(
        color: color,
        elevation: 20, // Aquí añades la elevación
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
                color: const Color.fromRGBO(6, 66, 106, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getTypeUser() async {
    String? user = await AuthUtils.getTipoUser();

    setState(() {
      typeUser = user;
    });
  }
}
