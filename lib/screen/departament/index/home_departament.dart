import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/config/config_url.dart';
import 'package:flutter_application_unipass/services/checks_service.dart';
import 'package:flutter_application_unipass/services/document_service.dart';
import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:intl/intl.dart';
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
  final DocumentService _DocumentService = DocumentService();
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
      List<dynamic> checks = [];

      if (idDormitorio != 0) {
        final checksSalida =
            await _checksService.obtenerChecksDormitorio(idDormitorio!);
        final checksFin =
            await _checksService.obtenerChecksDormitorioFin(idDormitorio!);
        checks.addAll(checksSalida);
        checks.addAll(checksFin);
      } else {
        final checksSalida = await _checksService.obtenerChecksVigilancia();
        final checksFin = await _checksService.obtenerChecksVigilanciaRegreso();
        checks.addAll(checksSalida);
        checks.addAll(checksFin);
      }

      for (var check in checks) {
        // Llama al servicio para obtener la foto de perfil
        String? relativeImageUrl =
            await _DocumentService.getProfile(check['IdUser'], 8);
        String? fullImageUrl =
            relativeImageUrl != null ? '$baseUrl$relativeImageUrl' : null;

        // Agrega la URL completa de la foto a cada check
        check['profilePic'] = fullImageUrl;
      }

      setState(() {
        _salidaChecks = checks
            .where((check) => check['Accion'] == 'SALIDA')
            .map((check) => {
                  'idCheck': check['IdCheck'],
                  'name': check['Nombre'],
                  'apellidos': check['Apellidos'],
                  'matricula': check['Matricula'],
                  'tipoSalida': check['Descripcion'],
                  'datetime': check['FechaSalida'],
                  'profilePic': check['profilePic'],
                })
            .toList();

        _retornoChecks = checks
            .where((check) => check['Accion'] == 'RETORNO')
            .map((check) => {
                  'idCheck': check['IdCheck'],
                  'name': check['Nombre'],
                  'apellidos': check['Apellidos'],
                  'matricula': check['Matricula'],
                  'tipoSalida': check['Descripcion'],
                  'datetime': check['FechaRegreso'],
                  'profilePic': check['profilePic'],
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
        centerTitle: true,
        title: isUserDataLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
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
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ToggleButtons(
                    onPressed: _onItemTapped,
                    isSelected: [_selectedIndex == 0, _selectedIndex == 1],
                    color: Colors.black,
                    fillColor: Colors.deepPurple,
                    selectedColor: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Salida'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Regreso'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _fetchChecks,
                    child: _selectedIndex == 0 && _salidaChecks.isEmpty ||
                            _selectedIndex == 1 && _retornoChecks.isEmpty
                        ? Center(
                            child: Text(
                              'No hay checks disponibles.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _selectedIndex == 0
                                ? _salidaChecks.length
                                : _retornoChecks.length,
                            itemBuilder: (context, index) {
                              final check = _selectedIndex == 0
                                  ? _salidaChecks[index]
                                  : _retornoChecks[index];

                              bool isApproved =
                                  check['Estatus'] == "Confirmada";

                              return GestureDetector(
                                onLongPress: () {
                                  _showObservationDialog(check, index);
                                },
                                child: Dismissible(
                                  key: Key(check['idCheck'].toString()),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    color: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    alignment: Alignment.centerLeft,
                                    child: const Icon(Icons.cancel,
                                        color: Colors.white),
                                  ),
                                  onDismissed: (direction) async {
                                    await _checksService.actualizarEstadoCheck(
                                        check['idCheck'],
                                        "No Confirmada",
                                        "Ninguna");
                                    setState(() {
                                      check['Estatus'] = "No Confirmada";
                                    });
                                  },
                                  child: CheckboxListTile(
                                    secondary: CircleAvatar(
                                      radius: 25,
                                      backgroundImage: check['profilePic'] !=
                                              null
                                          ? NetworkImage(check['profilePic'])
                                          : AssetImage(
                                                  'assets/default_profile.png')
                                              as ImageProvider,
                                    ),
                                    title: Text(
                                        '${_selectedIndex == 0 ? 'Salida' : 'Retorno'}: ${check['name']} ${check['apellidos']}'),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Matrícula: ${check['matricula']}'),
                                        Text(
                                            'Tipo de salida: ${check['tipoSalida']}'),
                                        //Text(check['Estatus'] == "Confirmada"
                                        //    ? 'Estatus: Confirmada'
                                        //    : 'Estatus: No Confirmada'),
                                        Text(
                                            'Fecha: ${DateFormat('dd/MM/yyyy h:mm:ss a').format(DateTime.parse(check['datetime']))}'),
                                      ],
                                    ),
                                    value: check['Estatus'] == "Confirmada",
                                    onChanged: (bool? value) async {
                                      if (value != null) {
                                        String estado = value
                                            ? "Confirmada"
                                            : "No Confirmada";

                                        // Actualiza el estado del check
                                        await _checksService
                                            .actualizarEstadoCheck(
                                                check['idCheck'],
                                                estado,
                                                "Ninguna");

                                        // Actualiza la lista para eliminar el elemento marcado
                                        setState(() {
                                          check['Estatus'] = estado;

                                          // Elimina el check si está confirmado y pertenece a la lista actual
                                          if (_selectedIndex == 0) {
                                            _salidaChecks.remove(check);
                                          } else if (_selectedIndex == 1) {
                                            _retornoChecks.remove(check);
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchChecks,
        child: const Icon(Icons.refresh, color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void _showObservationDialog(Map<String, dynamic> check, int index) {
    TextEditingController observationController = TextEditingController();
    final Responsive responsive = Responsive.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive.wp(10)),
          ),
          child: Padding(
            padding: EdgeInsets.all(responsive.wp(5)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Agregar Observación',
                  style: TextStyle(
                    fontSize: responsive.dp(2.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: responsive.hp(5)),
                TextField(
                  controller: observationController,
                  decoration: InputDecoration(
                    hintText: 'Escribe tu observación',
                    hintStyle: TextStyle(
                      fontSize: responsive.dp(1.8),
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                SizedBox(height: responsive.hp(5)),
                SizedBox(
                  width: responsive.wp(80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: responsive.wp(30), // Ancho del botón "Cancelar"
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(
                                vertical: responsive.hp(1.6)),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(responsive.wp(30)),
                            ),
                          ),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              fontSize: responsive.dp(2),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: responsive.wp(5)),
                      SizedBox(
                        width: responsive.wp(30), // Ancho del botón "Confirmar"
                        child: ElevatedButton(
                          onPressed: () async {
                            String observacion = observationController.text;
                            if (observacion.isNotEmpty) {
                              await _checksService.actualizarEstadoCheck(
                                check['idCheck'],
                                "Confirmada",
                                observacion,
                              );
                              setState(() {
                                check['Estatus'] = "Confirmada";
                                if (_selectedIndex == 0 &&
                                    index < _salidaChecks.length) {
                                  _salidaChecks.removeAt(index);
                                } else if (_selectedIndex == 1 &&
                                    index < _retornoChecks.length) {
                                  _retornoChecks.removeAt(index);
                                }
                              });
                              Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(250, 198, 0, 1),
                            padding: EdgeInsets.symmetric(
                                vertical: responsive.hp(1.6)),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(responsive.wp(30)),
                            ),
                          ),
                          child: Text(
                            'Confirmar',
                            style: TextStyle(
                              fontSize: responsive.dp(2),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
