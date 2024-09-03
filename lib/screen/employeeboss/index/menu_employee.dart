import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
import 'package:flutter_application_unipass/utils/imports.dart';

class MenuEmployeeScreen extends StatefulWidget {
  static const routeName = '/menuEmployee';
  const MenuEmployeeScreen({super.key});

  @override
  State<MenuEmployeeScreen> createState() => _MenuEmployeeScreenState();
}

class _MenuEmployeeScreenState extends State<MenuEmployeeScreen> {
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
                    '/AuthorizationEmployee',
                    Colors.blue,
                  ),
                  _buildMenuItem(
                    context,
                    'Ayuda',
                    'assets/image/HelpApp.svg',
                    '/helpUser',
                    const Color.fromARGB(255, 101, 181, 104),
                  ),
                  //Condiconar si el usuario es vigilancia para crear usuario de checks
                  if (typeUser == 'VIGILANCIA')
                    _buildMenuItem(
                        context,
                        'Checks',
                        'assets/image/checks.svg',
                        '/NewProfileChecks',
                        const Color.fromARGB(255, 80, 85, 221)),
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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(assetPath, width: 80, height: 80),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
