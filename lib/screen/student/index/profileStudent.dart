import 'package:flutter_application_unipass/utils/imports.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profileStudent';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notificationsStudent');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/alumno.png'),
            ),
            const SizedBox(height: 16),
            const Text('Alumno', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            const Text('Activar notificaciones'),
            Switch(value: true, onChanged: (bool value) {}),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  _buildProfileItem(
                    context,
                    'Cambiar contraseña',
                    'assets/image/cambiar_contra.svg',
                    '/changeStudent',
                    Colors.blue,
                  ),
                  _buildProfileItem(
                      context,
                      'Soporte',
                      'assets/image/soporte.svg',
                      '/supportUser',
                      Colors.yellow),
                  _buildProfileItem(
                      context,
                      'Políticas de Privacidad',
                      'assets/image/politicas.svg',
                      '/privacyUser',
                      Colors.green),
                  _buildProfileItem(context, 'Cerrar sesión',
                      'assets/image/cerrar_sesion.svg', '/login', Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, String title, String assetPath,
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
            Text(title),
          ],
        ),
      ),
    );
  }
}
