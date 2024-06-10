import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profileStudent';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.account_circle,
            color: const Color.fromARGB(255, 255, 255, 255)),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Perfil',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Añade aquí el contenido del perfil del usuario
          ],
        ),
      ),
    );
  }
}
