import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  static const routeName = '/menuStudent';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.purple),
            onPressed: () {
              Navigator.pushNamed(context, '/notificationsStudent');
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Menu',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              delegate: SliverChildListDelegate([
                _buildMenuItem('Salidas', Colors.blue, Icons.directions_walk),
                _buildMenuItem('Ayuda', Colors.red, Icons.help),
                _buildMenuItem(
                    'Documentos', Colors.green, Icons.insert_drive_file),
                _buildMenuItem('Cambiar contraseña', Colors.teal, Icons.lock),
                _buildMenuItem('Soporte', Colors.brown, Icons.support),
                _buildMenuItem('Políticas de Privacidad', Colors.orange,
                    Icons.privacy_tip),
                _buildMenuItem('Cerrar sesión', Colors.red, Icons.logout),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
            tooltip: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '',
            tooltip: 'Menu',
            // No se puede usar onTap en BottomNavigationBarItem, se usa onTap en BottomNavigationBar
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
            tooltip: 'Perfil',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/indexStudent');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/menuStudent');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profileStudent');
          }
        },
      ),
    );
  }

  Widget _buildMenuItem(String title, Color color, IconData icon) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // Define la acción cuando se presiona cada ítem
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 48),
              SizedBox(height: 8),
              Text(
                title,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
