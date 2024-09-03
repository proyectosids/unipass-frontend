import 'package:flutter_application_unipass/utils/imports.dart';

class HomeDepartament extends StatefulWidget {
  static const routeName = '/homeDepartamentIndex';
  const HomeDepartament({super.key});

  @override
  State<HomeDepartament> createState() => _HomeDepartamentState();
}

class _HomeDepartamentState extends State<HomeDepartament> {
  String? nombre;
  String? apellidos;
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _departures = [
    {'name': 'Erick', 'approved': true},
    {'name': 'Alan', 'approved': false},
    {'name': 'Levi', 'approved': true},
    {'name': 'Pablo', 'approved': true},
    {'name': 'Jhonatah', 'approved': true},
    {'name': 'Diego', 'approved': false},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_MX', null);
    _getNombreUser();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido ${nombre ?? 'Estudiante'}',
              style: TextStyle(fontSize: responsive.dp(2.2)),
            ),
            if (apellidos != null)
              Text(
                apellidos!,
                style: TextStyle(
                    fontSize: responsive.dp(1.8),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToggleButtons(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Salida'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Regreso'),
                ),
              ],
              onPressed: _onItemTapped,
              isSelected: [_selectedIndex == 0, _selectedIndex == 1],
              color: Colors.black,
              fillColor: Colors.deepPurple,
              selectedColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _departures.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text('Salida de ${_departures[index]['name']}'),
                  subtitle: Text(_departures[index]['approved']
                      ? 'Aprobada'
                      : 'No Aprobada'),
                  value: _departures[index]['approved'],
                  onChanged: (bool? value) {
                    setState(() {
                      _departures[index]['approved'] = value!;
                    });
                  },
                  secondary: Icon(
                    _departures[index]['approved'] ? Icons.check : Icons.close,
                    color: _departures[index]['approved']
                        ? Colors.green
                        : Colors.red,
                  ),
                );
              },
            ),
          ),
        ],
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
