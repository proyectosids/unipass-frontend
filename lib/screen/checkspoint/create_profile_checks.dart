import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/services/user_checkers_service.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateProfileChecks extends StatefulWidget {
  static const RouteName = '/NewProfileChecks';
  const CreateProfileChecks({super.key});

  @override
  State<CreateProfileChecks> createState() => _CreateProfileChecksState();
}

class _CreateProfileChecksState extends State<CreateProfileChecks> {
  final UserCheckersService _userCheckersService = UserCheckersService();
  List<dynamic> _checkers = [];
  bool _isLoading = false;

  Future<void> _fetchCheckers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? correo = prefs.getString('correo');

    if (correo == null || correo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No se encontró un correo en preferencias')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final checkers = await _userCheckersService.buscarChecker(correo);
      setState(() {
        _checkers = checkers; // Asigna directamente la lista recibida.
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _changeActivity(
      int id, int statusActividad, String matricula) async {
    try {
      await _userCheckersService.deleteChecker(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Actividad cambiada exitosamente')),
      );
      _fetchCheckers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cambiar actividad: $e')),
      );
    }
  }

  Future<void> _deleteUser(int id) async {
    try {
      await _userCheckersService.deleteChecker(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Actividad cambiada exitosamente')),
      );
      _fetchCheckers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cambiar actividad: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCheckers();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(3);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Gestión de Checkers',
            style: TextStyle(
              color: Colors.white,
              fontSize: responsive.dp(2.2),
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: const Color.fromRGBO(6, 66, 106, 1),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Color.fromRGBO(250, 198, 0, 1)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaciado
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        ListView.builder(
                          shrinkWrap: true, // Ajusta su tamaño al contenido
                          physics:
                              const NeverScrollableScrollPhysics(), // Sin scroll interno
                          itemCount: _checkers.length,
                          itemBuilder: (context, index) {
                            final checker = _checkers[index];
                            return GestureDetector(
                              onLongPress: () {
                                _deleteUser(checker['IdLogin']);
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                      '${checker['Nombre']} ${checker['Apellidos']}'),
                                  subtitle: Text(
                                      'Matrícula: ${checker['Matricula']}'),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _fetchCheckers,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(250, 198, 0, 1),
                        padding:
                            EdgeInsets.symmetric(vertical: responsive.hp(1.6)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              responsive.wp(10)), // Bordes redondeados
                        ),
                      ),
                      child: Text(
                        'Actualizar Lista',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: responsive.dp(2),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: responsive.wp(2)), // Espaciado entre botones
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.pushNamed(
                            context, '/CreateUserChecks');
                        if (result == true) {
                          _fetchCheckers();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(250, 198, 0, 1),
                        padding:
                            EdgeInsets.symmetric(vertical: responsive.hp(1.6)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              responsive.wp(10)), // Bordes redondeados
                        ),
                      ),
                      child: Text(
                        'Crear Usuario',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: responsive.dp(2),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
