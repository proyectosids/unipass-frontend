import 'dart:io';
import 'package:flutter_application_unipass/utils/imports.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeStudentScreen(),
    );
  }
}

class HomeStudentScreen extends StatefulWidget {
  static const routeName = '/indexStudent';

  @override
  _HomeStudentScreenState createState() => _HomeStudentScreenState();
}

class _HomeStudentScreenState extends State<HomeStudentScreen> {
  bool isAvisosSelected = true;
  int _selectedIndex = 0; // Mantiene el índice seleccionado

  final List<Widget> _pages = [
    // Lista de pantallas
    HomeScreenContent(),
    MenuScreenContent(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.account_circle, color: Colors.purple),
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
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
            tooltip: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '',
            tooltip: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
            tooltip: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Actualiza el índice seleccionado
          });
        },
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hola Alumno',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '¿Qué haremos hoy?',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 16),
          AvisosEnProcesoSwitcher(),
          SizedBox(height: 16),
          Text(
            'Actividad',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Número de actividades (ajustar según tu lógica)
              itemBuilder: (context, index) {
                return ActivityItem(
                  title: 'Salida al pueblo',
                  timeAgo: 'hace ${12 * (index + 1)} horas',
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MenuScreenContent extends StatelessWidget {
  static const routeName = '/menuScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildMenuItem(
                'Salidas', Colors.blue, Icons.directions_walk, context),
            _buildMenuItem('Ayuda', Colors.red, Icons.help, context),
            _buildMenuItem(
                'Documentos', Colors.green, Icons.insert_drive_file, context),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      String title, Color color, IconData icon, BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          if (title == 'Salidas') {
            Navigator.pushNamed(context, '/ExitStudent');
          } else {
            // Otras acciones para diferentes ítems de menú
          }
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

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile == null
                    ? AssetImage('assets/default_user.png')
                    : FileImage(File(_imageFile!.path)) as ImageProvider,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: _pickImage,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Alumno',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SwitchListTile(
            title: Text('Activar notificaciones'),
            value: true,
            onChanged: (bool value) {},
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
              ),
              children: [
                _buildGridItem(
                  context,
                  color: Colors.green,
                  icon: Icons.lock,
                  label: 'Cambiar contraseña',
                  onTap: () {},
                ),
                _buildGridItem(
                  context,
                  color: Colors.purple,
                  icon: Icons.support,
                  label: 'Soporte',
                  onTap: () {},
                ),
                _buildGridItem(
                  context,
                  color: Colors.orange,
                  icon: Icons.privacy_tip,
                  label: 'Políticas de Privacidad',
                  onTap: () {},
                ),
                _buildGridItem(
                  context,
                  color: Colors.red,
                  icon: Icons.logout,
                  label: 'Cerrar sesión',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context,
      {required Color color,
      required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              label,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AvisosEnProcesoSwitcher extends StatefulWidget {
  @override
  _AvisosEnProcesoSwitcherState createState() =>
      _AvisosEnProcesoSwitcherState();
}

class _AvisosEnProcesoSwitcherState extends State<AvisosEnProcesoSwitcher> {
  bool isAvisosSelected = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isAvisosSelected = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isAvisosSelected ? Colors.lime : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Avisos',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isAvisosSelected = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isAvisosSelected ? Colors.grey : Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'En proceso',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        _buildCarousel(),
      ],
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(height: 200.0),
      items: isAvisosSelected
          ? [
              _buildCard('Preceptor', 'Nueva regla de salidas a casa',
                  '25 Mayo, 2024', Colors.purple),
              _buildCard('Jefe de área', 'Alumnos pendientes con horas',
                  '22 Mayo, 2024', Colors.orange),
            ]
          : [
              _buildCard('Preceptor', 'Solicitud a casa', '30 Mayo, 2024',
                  Colors.purple),
              _buildCard('Jefe de área', 'Solicitud al pueblo', '23 Mayo, 2024',
                  Colors.orange),
            ],
    );
  }

  Widget _buildCard(String title, String subtitle, String date, Color color) {
    return GestureDetector(
      onLongPress: () {
        _showDetailsDialog(title, subtitle, date, color);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  date,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailsDialog(
      String title, String subtitle, String date, Color color) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                date,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cerrar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ActivityItem extends StatefulWidget {
  final String title;
  final String timeAgo;
  final int index;

  ActivityItem(
      {required this.title, required this.timeAgo, required this.index});

  @override
  _ActivityItemState createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(Icons.event, color: Colors.purple),
        title: Text(widget.title),
        subtitle: Text(widget.timeAgo),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'delete',
              child: Text('Eliminar'),
            ),
          ],
          onSelected: (value) {
            if (value == 'delete') {
              setState(() {
                // Aquí deberías llamar a una función para eliminar la actividad del estado global
              });
            }
          },
        ),
      ),
    );
  }
}
