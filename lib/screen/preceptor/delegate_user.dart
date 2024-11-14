import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/config/config_url.dart';
import 'package:flutter_application_unipass/services/auth_service.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DelegatePositionScreen extends StatefulWidget {
  static const routeName = '/delegatePosition';

  const DelegatePositionScreen({Key? key}) : super(key: key);

  @override
  _DelegatePositionScreenState createState() => _DelegatePositionScreenState();
}

class _DelegatePositionScreenState extends State<DelegatePositionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _matriculaController = TextEditingController();
  final _classUserController = TextEditingController();
  final _asignadoController = TextEditingController();
  final _nombreController = TextEditingController();
  final AuthServices _authServices = AuthServices();
  bool _isLoading = false;
  dynamic _personaInfo;

  Future<void> _delegatePosition() async {
    final matriculaEncargado = _matriculaController.text;
    final classUser = _classUserController.text;
    final asignado = _asignadoController.text;

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Delegación realizada exitosamente")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al delegar el cargo")),
      );
    }
  }

  Future<void> _buscarPersona() async {
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
                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Buscar por Nombre',
                      labelStyle: TextStyle(fontSize: responsive.dp(1.8)),
                    ),
                  ),
                  SizedBox(height: responsive.hp(2)),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _buscarPersona,
                    child: Text('Buscar Persona'),
                  ),
                  if (_personaInfo != null) ...[
                    SizedBox(height: responsive.hp(2)),
                    Text(
                      'Información de la Persona:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _personaInfo is List
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _personaInfo.length,
                            itemBuilder: (context, index) {
                              final user = _personaInfo[index];
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(
                                      "${user['Nombre']} ${user['Apellidos']}"),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${user['TipoUser']}"),
                                      Text("${user['Celular']}"),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                  "${_personaInfo['Nombre']} ${_personaInfo['Nombre']}"),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${_personaInfo['TipoUser']}"),
                                  Text("${_personaInfo['Celular']}"),
                                ],
                              ),
                            ),
                          ),
                  ],
                  SizedBox(height: responsive.hp(3)),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(6, 66, 106, 1),
                            padding: EdgeInsets.symmetric(
                              vertical: responsive.hp(2),
                              horizontal: responsive.wp(10),
                            ),
                          ),
                          onPressed: _delegatePosition,
                          child: Text(
                            'Delegar',
                            style: TextStyle(
                              fontSize: responsive.dp(1.8),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
    _matriculaController.dispose();
    _classUserController.dispose();
    _asignadoController.dispose();
    _nombreController.dispose();
    super.dispose();
  }
}
