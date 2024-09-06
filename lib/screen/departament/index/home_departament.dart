import 'package:flutter_application_unipass/services/checks_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomeDepartament extends StatefulWidget {
  static const routeName = '/homeDepartamentIndex';

  const HomeDepartament({Key? key}) : super(key: key);

  @override
  State<HomeDepartament> createState() => _HomeDepartamentState();
}

class _HomeDepartamentState extends State<HomeDepartament> {
  int? idDormitorio;
  String? nombre;
  String? apellidos;
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _salidaChecks = [];
  List<Map<String, dynamic>> _retornoChecks = [];
  bool isLoading = true;
  bool isUserDataLoading =
      true; // Controla si los datos de usuario están cargados
  final ChecksService _checksService = ChecksService();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_MX', null);
    _loadUserDataAndFetchChecks(); // Cargamos los datos del usuario antes de hacer el fetch
  }

  // Cargar los datos del usuario y luego obtener los checks
  Future<void> _loadUserDataAndFetchChecks() async {
    await _getNombreUser(); // Esperamos a que los datos del usuario se carguen
    if (idDormitorio != null) {
      await _fetchChecks(); // Solo llamamos a fetchChecks después de obtener el idDormitorio
    } else {
      setState(() {
        isLoading = false; // Detenemos la carga si no hay idDormitorio
      });
    }
  }

  // Obtener los checks
  Future<void> _fetchChecks() async {
    setState(() {
      isLoading = true; // Indicamos que los checks se están cargando
    });
    try {
      List<dynamic> checks;
      if (idDormitorio != 0) {
        checks = await _checksService.obtenerChecksDormitorio(idDormitorio!);
      } else {
        checks = await _checksService.obtenerChecksVigilancia();
      }

      // Asegúrate de imprimir los checks para verificar si llegan correctamente
      print('Checks obtenidos: $checks');

      setState(() {
        _salidaChecks = checks
            .where((check) => check['Accion'] == 'SALIDA')
            .map((check) => {
                  'name': check['Nombre'],
                  'approved': check['StatusCheck'] == 'Aprobada',
                })
            .toList();
        _retornoChecks = checks
            .where((check) => check['Accion'] == 'RETORNO')
            .map((check) => {
                  'name': check[
                      'Nombre'], // Asegúrate de que este campo sea correcto
                  'approved': check['StatusCheck'] == 'Aprobada',
                })
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error al obtener los checks: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: isUserDataLoading
            ? CircularProgressIndicator() // Mostrar un indicador de carga mientras se obtienen los datos del usuario
            : Column(
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
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
                    itemCount: _selectedIndex == 0
                        ? _salidaChecks.length
                        : _retornoChecks.length,
                    itemBuilder: (context, index) {
                      final check = _selectedIndex == 0
                          ? _salidaChecks[index]
                          : _retornoChecks[index];

                      return CheckboxListTile(
                        title: Text(
                            '${_selectedIndex == 0 ? 'Salida' : 'Retorno'} de ${check['name']}'),
                        subtitle: Text(
                            check['approved'] ? 'Aprobada' : 'No Aprobada'),
                        value: check['approved'],
                        onChanged: (bool? value) {
                          // Debería ser solo visual, así que este onChanged puede quedar vacío.
                        },
                        secondary: Icon(
                          check['approved'] ? Icons.check : Icons.close,
                          color: check['approved'] ? Colors.green : Colors.red,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  // Obtener datos del usuario
  Future<void> _getNombreUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nombreUsuario = prefs.getString('nombre');
    String? apellidosUsuario = prefs.getString('apellidos');
    int? dormitorioId = await AuthUtils.getIdDormitorio();

    setState(() {
      nombre = nombreUsuario;
      apellidos = apellidosUsuario;
      idDormitorio = dormitorioId;
      isUserDataLoading =
          false; // Indicamos que la carga de datos de usuario ha terminado
    });
  }

  // Método para cambiar de pestaña en el toggle button
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
