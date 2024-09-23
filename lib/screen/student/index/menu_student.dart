import 'package:flutter_application_unipass/utils/imports.dart';

class MenuScreen extends StatelessWidget {
  static const routeName = '/menu';

  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Menu'),
        centerTitle: true,
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
                    '/ExitStudent',
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
                    '/documentStudent',
                    Colors.white,
                  ),
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
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
