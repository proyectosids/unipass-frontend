import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/config/config_url.dart';
import 'package:flutter_application_unipass/services/auth_service.dart';
import 'package:flutter_application_unipass/services/notification_service.dart';
import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DelegatePositionScreen extends StatefulWidget {
  static const routeName = '/delegatePosition';

  const DelegatePositionScreen({Key? key}) : super(key: key);

  @override
  _DelegatePositionScreenState createState() => _DelegatePositionScreenState();
}

class _DelegatePositionScreenState extends State<DelegatePositionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final AuthServices _authServices = AuthServices();
  bool _isLoading = false;
  dynamic _personaInfo;
  List<dynamic> _matriculaInfo = [];

  Future<void> _eliminarAsignacion(String matricula) async {
    if (matricula.isEmpty) return;

    final url = Uri.parse('$baseUrl/terminarCargo/$matricula');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        _matriculaInfo
            .removeWhere((persona) => persona['Matricula'] == matricula);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Asignación eliminada exitosamente")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al eliminar la asignación")),
      );
    }
  }

  Future<void> _buscarPersona() async {
    //Comentado para permitir buscar mas usuarios

    //if (_matriculaInfo != null) {
    //  ScaffoldMessenger.of(context).showSnackBar(
    //    const SnackBar(
    //        content: Text(
    //            "Ya hay una persona asignada. Elimina primero la asignación para buscar otra.")),
    //  );
    //  return;
    //}

    final nombre = _nombreController.text;
    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Por favor, ingrese un nombre para buscar")),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);
      final personaInfo = await _authServices.buscarpersona(nombre);
      setState(() {
        _personaInfo = personaInfo;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al buscar la persona: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<List<Map<String, dynamic>>> _deactivateAll() async {
    List<Map<String, dynamic>> deactivatedUsers = [];
    for (var persona in _matriculaInfo) {
      if (persona['Activo'] == 1) {
        final url = Uri.parse('$baseUrl/activarCargo/${persona['IdCargo']}');
        final response = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'Activo': 0}),
        );
        if (response.statusCode == 200) {
          setState(() {
            persona['Activo'] = 0;
          });
          deactivatedUsers
              .add(persona); // Añade la persona desactivada a la lista
        }
      }
    }
    return deactivatedUsers;
  }

  Future<void> _toggleActivo(bool isActive, String matricula) async {
    var index = _matriculaInfo
        .indexWhere((element) => element['Matricula'] == matricula);
    if (index == -1) return; // Si no encuentra la matrícula, termina la función

    // Obtener datos del usuario que realiza la acción
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nombre = prefs.getString('nombre');
    String? apellido = prefs.getString('apellidos');
    String? departamento = prefs.getString('nombreDepartamento');

    List<Map<String, dynamic>> deactivatedUsers = await _deactivateAll();
    // Notificar a todos los delegados desactivados
    for (var user in deactivatedUsers) {
      String? token = user['TokenCFM'];
      if (token != null && token.isNotEmpty) {
        await NotificationService().sendNotificationToServer(
            token,
            "Has sido relevado como Jefe de Departamento",
            "$nombre $apellido ha finalizado tu asignación temporal como encargado de $departamento.");
      }
    }

    // Activar o desactivar el delegado seleccionado
    final url =
        Uri.parse('$baseUrl/activarCargo/${_matriculaInfo[index]['IdCargo']}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'Activo': isActive ? 1 : 0}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _matriculaInfo[index]['Activo'] = isActive ? 1 : 0;
      });

      // Notificar al delegado activado, si corresponde
      if (isActive) {
        String? token = _matriculaInfo[index]['TokenCFM'];
        if (token != null && token.isNotEmpty) {
          await NotificationService().sendNotificationToServer(
              token,
              "Has sido delegado como Jefe de Departamento",
              "$nombre $apellido te ha asignado temporalmente como encargo de $departamento para desempeñar ciertas funciones.");
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(isActive
              ? "Persona activada exitosamente"
              : "Persona desactivada exitosamente")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al actualizar el estado")));
    }
  }

  Future<void> _delegatePosition(
      String matriculaEncargado, String classUser, String asignado) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('$baseUrl/createPosition');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'MatriculaEncargado': matriculaEncargado,
        'ClassUser': classUser,
        'Asignado': asignado,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final createdData =
          responseData['data']; // Datos creados devueltos por el backend
      final int createdId =
          createdData['IdCargo']; // Extrae el id de los datos creados

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Delegación realizada exitosamente")),
      );

      // Llama a _updateCargo con el ID creado
      await _updateCargo(asignado, createdId);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al delegar el cargo")),
      );
    }
  }

  Future<void> _updateCargo(String matricula, int delegado) async {
    final url = Uri.parse('$baseUrl/cambiarCargo/$matricula');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'IdCargoDelegado': delegado}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cargo actualizado exitosamente")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al actualizar el cargo")),
      );
    }
  }

  Future<void> _obtenerInfoMatricula() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? matricula = prefs.getString('matricula');
    try {
      setState(() => _isLoading = true);
      var matriculaInfo = await _authServices.userInfoDelegado(matricula!);
      setState(() {
        _matriculaInfo = matriculaInfo;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Información de la matrícula obtenida")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al obtener la matrícula: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showAssignDialog(
      String nombreCompleto, String userId, String classUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? matricula = prefs.getString('matricula');
    String? user = await AuthUtils.getTipoUser();

    if (matricula == null) {
      print('Matricula not found');
      return;
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Impide cerrar el diálogo al hacer clic fuera
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Delegación'),
          content: Text('¿Deseas asignar tu cargo a $nombreCompleto?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sí'),
              onPressed: () {
                Navigator.of(context).pop();
                _delegatePosition(matricula, user!,
                    userId); // Llama a la función de delegación con parámetros
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _obtenerInfoMatricula(); // Llama a la función al iniciar el widget
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Delegar Cargo',
            style: TextStyle(
              color: Colors.white,
              fontSize: responsive.dp(2.2),
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: const Color.fromRGBO(6, 66, 106, 1),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromRGBO(250, 198, 0, 1),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(responsive.wp(3)),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado "Persona Asignada"
                  Text(
                    'Persona Asignada',
                    style: TextStyle(
                      fontSize: responsive.dp(2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: responsive.hp(1)),

// Comprobación y muestra de la lista de personas asignadas
                  if (_matriculaInfo.isEmpty)
                    Text(
                      "No hay personas asignadas",
                      style: TextStyle(
                        fontSize: responsive.dp(1.8),
                        color: Colors.grey,
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap:
                          true, // Importante para no expandir indefinidamente dentro de una columna
                      physics:
                          NeverScrollableScrollPhysics(), // Deshabilita el scrolling propio del ListView
                      itemCount: _matriculaInfo.length,
                      itemBuilder: (context, index) {
                        var persona = _matriculaInfo[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                                "${persona['Nombre']} ${persona['Apellidos']}"),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${persona['TipoUser']}"),
                                Text("${persona['Celular']}"),
                              ],
                            ),
                            trailing: Switch(
                              value: persona['Activo'] == 1,
                              onChanged: (bool newValue) {
                                _toggleActivo(newValue, persona['Matricula']);
                              },
                            ),
                            onLongPress: () {
                              _eliminarAsignacion(persona['Matricula']);
                            },
                          ),
                        );
                      },
                    ),

                  SizedBox(
                    height: responsive.hp(3),
                  ),
                  // Campo de búsqueda de persona
                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Buscar por Nombre',
                      labelStyle: TextStyle(fontSize: responsive.dp(1.8)),
                    ),
                  ),
                  SizedBox(height: responsive.hp(2)),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _buscarPersona,
                      child: Text('Buscar Persona'),
                    ),
                  ),

                  // Mostrar información de la persona buscada
                  if (_personaInfo != null && _personaInfo is List)
                    _personaInfo.isEmpty
                        ? Text(
                            "No hay usuarios disponibles",
                            style: TextStyle(
                              fontSize: responsive.dp(1.8),
                              color: Colors.grey,
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _personaInfo.length,
                            itemBuilder: (context, index) {
                              final user = _personaInfo[index];
                              if (user['ExisteEnPosition'] !=
                                  "No existe en Position") {
                                return SizedBox.shrink();
                              }
                              final nombreCompleto =
                                  "${user['Nombre']} ${user['Apellidos']}";
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(nombreCompleto),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${user['TipoUser']}"),
                                      Text("${user['Celular']}"),
                                    ],
                                  ),
                                  onLongPress: () {
                                    _showAssignDialog(nombreCompleto,
                                        user['Matricula'], user['TipoUser']);
                                  },
                                ),
                              );
                            },
                          )
                  else if (_personaInfo == null)
                    SizedBox.shrink()
                  else
                    Text(
                      "No hay usuarios disponibles",
                      style: TextStyle(
                        fontSize: responsive.dp(1.8),
                        color: Colors.grey,
                      ),
                    ),

                  if (_isLoading) Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }
}
