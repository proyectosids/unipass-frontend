import 'package:flutter_application_unipass/utils/imports.dart';

class HomeStudentScreen extends StatefulWidget {
  static const routeName = '/homeStudent';

  const HomeStudentScreen({Key? key}) : super(key: key);

  @override
  _HomeStudentScreenState createState() => _HomeStudentScreenState();
}

class _HomeStudentScreenState extends State<HomeStudentScreen> {
  bool isAvisosSelected = true;
  String? nombre;
  String? apellidos;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_MX', null);
    _getNombreUser();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(3);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true, // Centra el título del AppBar
        title: Column(
          mainAxisSize: MainAxisSize
              .min, // Esto asegura que la columna ocupe solo el espacio necesario
          children: [
            Text(
              'Bienvenido, ${nombre ?? 'Empleado'}',
              style: TextStyle(
                fontSize: responsive.dp(2.2),
                fontFamily: 'Roboto',
              ),
            ),
            if (apellidos != null)
              Text(
                apellidos!,
                style: TextStyle(
                    fontSize: responsive.dp(1.4),
                    color: const Color.fromARGB(255, 138, 138, 138)),
              ),
          ],
        ),
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
        padding: EdgeInsets.all(padding),
        child: SingleChildScrollView(
          // Envuelve el contenido en SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('¿Qué haremos hoy?',
                  style: TextStyle(fontSize: responsive.dp(2.4))),
              SizedBox(height: responsive.hp(1.8)),
              Row(
                children: [
                  _buildStatusButton('Avisos', isAvisosSelected),
                  SizedBox(width: responsive.wp(3)),
                  _buildStatusButton('En proceso', !isAvisosSelected),
                ],
              ),
              SizedBox(height: responsive.hp(1.5)),
              _buildCards(),
              SizedBox(height: responsive.hp(1.5)),
              Text('Actividad', style: TextStyle(fontSize: responsive.dp(2.2))),
              _buildActivityList(), // Ya maneja un ListView para la actividad
            ],
          ),
        ),
      ),
    );
  }

//Responsives pendientes hacia abajo
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
              'Alumnos pendientes de horas',
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
    return ListView(
      shrinkWrap: true, // Permite anidar dentro de un SingleChildScrollView
      physics:
          NeverScrollableScrollPhysics(), // Evita el desplazamiento interno
      children: [
        _buildActivityItem('Salida al pueblo', 'hace 12 horas'),
        _buildActivityItem('Salida al pueblo', 'hace 5 días'),
        _buildActivityItem('Salida especial', 'hace 15 días'),
      ],
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

  Future<void> _getNombreUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nombreUsuario = prefs.getString('nombre');
    String? apellidosUsuario = prefs.getString('apellidos');

    setState(() {
      nombre = nombreUsuario;
      apellidos = apellidosUsuario;
    });
  }
}
