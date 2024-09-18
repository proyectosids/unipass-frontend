import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/services/checks_service.dart';
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
  bool isUserDataLoading = true;
  final ChecksService _checksService = ChecksService();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_MX', null);
    _loadUserDataAndFetchChecks();
  }

  Future<void> _loadUserDataAndFetchChecks() async {
    await _getNombreUser();
    if (idDormitorio != null) {
      await _fetchChecks();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchChecks() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<dynamic> checks;
      if (idDormitorio != 0) {
        checks = await _checksService.obtenerChecksDormitorio(idDormitorio!);
      } else {
        checks = await _checksService.obtenerChecksVigilancia();
      }

      setState(() {
        _salidaChecks = checks
            .where((check) => check['Accion'] == 'SALIDA')
            .map((check) => {
                  'idCheck': check['IdCheck'],
                  'name': check['Nombre'],
                  'Estatus': check['Estatus'],
                })
            .toList();
        _retornoChecks = checks
            .where((check) => check['Accion'] == 'RETORNO')
            .map((check) => {
                  'idCheck': check['IdCheck'],
                  'name': check['Nombre'],
                  'Estatus': check['Estatus'],
                  'linkedSalida': _salidaChecks.firstWhere(
                      (salidaCheck) => salidaCheck['name'] == check['Nombre'],
                      orElse: () => {
                            'idCheck': null,
                            'name': check['Nombre'],
                            'Estatus': 'No Confirmada',
                          }) // Proporciona un valor por defecto si no encuentra una salida
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
            ? CircularProgressIndicator()
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

                      // Determinar si el checkbox está marcado o no
                      bool isApproved = check['Estatus'] == "Confirmada";

                      // Verifica si la salida está confirmada para permitir el retorno
                      return Dismissible(
                        key: Key(check['idCheck'].toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerLeft,
                          child: Icon(Icons.cancel, color: Colors.white),
                        ),
                        onDismissed: (direction) async {
                          await _checksService.actualizarEstadoCheck(
                              check['idCheck'], "No Confirmada", "Ninguna");
                          setState(() {
                            check['Estatus'] = "No Confirmada";
                            //_salidaChecks.removeAt(index);
                          });
                        },
                        child: CheckboxListTile(
                          title: Text(
                              '${_selectedIndex == 0 ? 'Salida' : 'Retorno'} de ${check['name']}'),
                          subtitle:
                              Text(isApproved ? 'Confirmada' : 'No Confirmada'),
                          value: isApproved,
                          onChanged: (bool? value) async {
                            if (_selectedIndex == 1) {
                              var salidaCheck = _salidaChecks.firstWhere(
                                  (s) =>
                                      s['name'] == check['name'] &&
                                      s['Estatus'] == "Confirmada",
                                  orElse: () => {
                                        'Estatus': 'No Confirmada'
                                      } // Corregido para devolver un mapa por defecto
                                  );
                              if (salidaCheck['Estatus'] == "Confirmada") {
                                if (value != null) {
                                  String estado =
                                      value ? "Confirmada" : "No Confirmada";
                                  await _checksService.actualizarEstadoCheck(
                                      check['idCheck'], estado, "Ninguna");
                                  setState(() {
                                    check['Estatus'] = estado;
                                  });
                                }
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text("Acción no permitida"),
                                          content: Text(
                                              "No se puede confirmar el regreso sin una salida confirmada."),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text("Cerrar"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        ));
                              }
                            } else {
                              if (value != null) {
                                String estado =
                                    value ? "Confirmada" : "No Confirmada";
                                await _checksService.actualizarEstadoCheck(
                                    check['idCheck'], estado, "Ninguna");
                                setState(() {
                                  check['Estatus'] = estado;
                                });
                              }
                            }
                          },
                          secondary: Icon(
                            isApproved ? Icons.check : Icons.close,
                            color: isApproved ? Colors.green : Colors.red,
                          ),
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
    int? dormitorioId = await AuthUtils.getIdDormitorio();

    setState(() {
      nombre = nombreUsuario;
      apellidos = apellidosUsuario;
      idDormitorio = dormitorioId;
      isUserDataLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
