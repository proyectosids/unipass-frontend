import 'package:flutter/material.dart';

class HomePreceptorScreen extends StatefulWidget {
  static const routeName = '/homePreceptor';

  const HomePreceptorScreen({Key? key}) : super(key: key);

  @override
  _HomePreceptorScreenState createState() => _HomePreceptorScreenState();
}

class _HomePreceptorScreenState extends State<HomePreceptorScreen> {
  bool isAvisosSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Hola Preceptor'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Qué haremos hoy?', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatusButton('Avisos', isAvisosSelected),
                const SizedBox(width: 8),
                _buildStatusButton('Solicitudes', !isAvisosSelected),
              ],
            ),
            const SizedBox(height: 16),
            _buildCards(),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Crear aviso',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Recientes', style: TextStyle(fontSize: 24)),
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
          backgroundColor: isSelected
              ? Colors.purple
              : const Color.fromARGB(255, 178, 178, 178),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
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
            _buildCard(
              'Departamento',
              'No deber horas para prácticas',
              '25 Mayo, 2024',
              Colors.purple,
              Icons.school,
            ),
            _buildCard(
              'Dormitorio',
              'Subir sus documentos para salir',
              '22 Mayo, 2024',
              Colors.blue,
              Icons.home,
            ),
          ],
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCircleCard('Pendientes', 7, Colors.yellow),
          _buildCircleCard('Pueblo', 3, Colors.green),
          _buildCircleCard('Especiales', 2, Colors.blue),
          _buildCircleCard('A casa', 2, Colors.orange),
        ],
      );
    }
  }

  Widget _buildCard(
      String title, String subtitle, String date, Color color, IconData icon) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(icon, color: Colors.white),
            title: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              date,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleCard(String title, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildActivityList() {
    return Expanded(
      child: ListView(
        children: [
          _buildActivityItem('Salida al pueblo alumno 11', 'hace 2 horas'),
          _buildActivityItem('Salida al pueblo alumno 152', 'hace 3 horas'),
          _buildActivityItem('Salida especial alumno 74', 'hace 5 horas'),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: const Icon(Icons.event, color: Colors.purple),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
