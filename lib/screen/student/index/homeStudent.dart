import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeStudentScreen extends StatefulWidget {
  static const routeName = '/homeStudent';

  const HomeStudentScreen({Key? key}) : super(key: key);

  @override
  _HomeStudentScreenState createState() => _HomeStudentScreenState();
}

class _HomeStudentScreenState extends State<HomeStudentScreen> {
  bool isAvisosSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hola Alumno'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Qué haremos hoy?', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatusButton('Avisos', isAvisosSelected),
                const SizedBox(width: 8),
                _buildStatusButton('En proceso', !isAvisosSelected),
              ],
            ),
            const SizedBox(height: 16),
            _buildCards(),
            const SizedBox(height: 16),
            const Text('Actividad', style: TextStyle(fontSize: 24)),
            _buildActivityList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String title, bool isSelected) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isAvisosSelected = title == 'Avisos';
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? Colors.purple : Color.fromARGB(255, 178, 178, 178),
          disabledForegroundColor: Colors.white.withOpacity(0.38),
          disabledBackgroundColor: Colors.white.withOpacity(0.12),
        ),
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCards() {
    if (isAvisosSelected) {
      return SizedBox(
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildCard('Preceptor', 'Nueva regla de salidas a casa',
                '25 Mayo, 2024', 'assets/image/anuncio.png'),
            _buildCard('Jefe de área', 'Alumnos pendientes con horas',
                '22 Mayo, 2024', 'assets/image/anuncio.png'),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildCard('Preceptor', 'Solicitud a casa', '30 Mayo, 2024',
                'assets/image/anuncio.png'),
            _buildCard('Jefe de área', 'Solicitud al pueblo', '23 Mayo, 2024',
                'assets/image/anuncio.png'),
          ],
        ),
      );
    }
  }

  Widget _buildCard(
      String title, String subtitle, String date, String assetPath) {
    return Container(
      width: 250, // Ajusta el ancho de las tarjetas según sea necesario
      margin: const EdgeInsets.only(right: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Image.asset(assetPath, width: 40, height: 40),
              title: Text(title),
              subtitle: Text(subtitle),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(date, style: const TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    return Expanded(
      child: ListView(
        children: [
          _buildActivityItem('Salida al pueblo', 'hace 12 horas'),
          _buildActivityItem('Salida al pueblo', 'hace 5 días'),
          _buildActivityItem('Salida especial', 'hace 15 días'),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(Icons.event, color: Colors.purple),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
