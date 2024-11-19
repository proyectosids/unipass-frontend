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
            children: [
              _isLoading
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _checkers.length,
                        itemBuilder: (context, index) {
                          final checker = _checkers[index];
                          return GestureDetector(
                            onLongPress: () {
                              _changeActivity(
                                checker['IdLogin'],
                                0,
                                checker['Matricula'],
                              );
                            },
                            child: Card(
                              child: ListTile(
                                title: Text(
                                    '${checker['Nombre']} ${checker['Apellidos']}'),
                                subtitle:
                                    Text('Matrícula: ${checker['Matricula']}'),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _fetchCheckers,
                    child: Text(
                      'Actualizar Lista',
                      style: TextStyle(fontSize: responsive.dp(1.8)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                          context, '/CreateUserChecks');
                      if (result == true) {
                        // Refrescar la lista si se creó un usuario
                        _fetchCheckers();
                      }
                    },
                    child: Text(
                      'Crear Usuario',
                      style: TextStyle(fontSize: responsive.dp(1.8)),
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
