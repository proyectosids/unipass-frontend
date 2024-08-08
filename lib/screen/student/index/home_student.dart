import 'package:flutter_application_unipass/utils/imports.dart';

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
        backgroundColor: Colors.white,
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
          backgroundColor: isSelected
              ? Colors.purple
              : const Color.fromARGB(255, 178, 178, 178),
          disabledForegroundColor: Colors.white.withOpacity(0.38),
          disabledBackgroundColor: Colors.white.withOpacity(0.12),
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
              'Preceptor',
              'Nueva regla de salidas a casa',
              '25 Mayo, 2024',
              Colors.purple,
              Icons.announcement,
            ),
            _buildCard(
              'Jefe de área',
              'Alumnos pendientes con horas',
              '22 Mayo, 2024',
              Colors.blue,
              Icons.announcement,
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildCard(
              'Preceptor',
              'Solicitud a casa',
              '30 Mayo, 2024',
              Colors.purple,
              Icons.announcement,
            ),
            _buildCard(
              'Jefe de área',
              'Solicitud al pueblo',
              '23 Mayo, 2024',
              Colors.blue,
              Icons.announcement,
            ),
          ],
        ),
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
        leading: const Icon(Icons.event, color: Colors.purple),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
