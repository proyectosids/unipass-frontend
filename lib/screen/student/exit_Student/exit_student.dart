import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
import 'package:flutter_application_unipass/utils/imports.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_unipass/services/permission_service.dart';

class ExitStudent extends StatefulWidget {
  static const routeName = '/ExitStudent';

  const ExitStudent({Key? key}) : super(key: key);

  @override
  _ExitStudentState createState() => _ExitStudentState();
}

class _ExitStudentState extends State<ExitStudent> {
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> _exits = [];
  final PermissionService _permissionService = PermissionService();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_MX', null);
    _loadExits();
  }

  Future<void> _loadExits() async {
    int? id = await AuthUtils.getUserId();
    if (id == null) {
      print('User ID not found');
      return;
    }

    try {
      List<Map<String, dynamic>> exits =
          await _permissionService.getPermissions(id);

      // Ordenar los permisos por fecha, asegurándose de que el más reciente esté primero
      exits.sort((a, b) {
        DateTime dateA = DateTime.parse(a['FechaSolicitada'] ?? '');
        DateTime dateB = DateTime.parse(b['FechaSolicitada'] ?? '');
        return dateB.compareTo(dateA); // Orden descendente
      });

      setState(() {
        _exits = exits;
      });
    } catch (e) {
      print('Failed to load exits: $e');
    }
  }

  Future<void> _cancelExit(int id) async {
    try {
      await _permissionService.cancelPermission(id);
      await _loadExits(); // Recargar las salidas después de cancelar
    } catch (e) {
      print('Failed to cancel exit: $e');
    }
  }

  void _addNewExit(Map<String, dynamic> newExit) {
    setState(() {
      _exits.insert(0, newExit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Salidas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildDatePicker(),
            const SizedBox(height: 16),
            const Text(
              'Salidas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _exits.length,
                itemBuilder: (context, index) {
                  final exit = _exits[index];
                  return exit['StatusPermission'] == 'Pendiente'
                      ? Dismissible(
                          key: Key(exit['IdPermission'].toString()),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await _showConfirmationDialog(context);
                          },
                          onDismissed: (direction) {
                            _cancelExit(exit['IdPermission']);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: _buildExitItem(
                            context,
                            'Salida ${exit['Descripcion'] ?? ''}',
                            exit['FechaSolicitada'] ?? '',
                            exit['FechaSalida'] ?? '',
                            exit['StatusPermission'] ?? '',
                            exit,
                          ),
                        )
                      : _buildExitItem(
                          context,
                          'Salida ${exit['Descripcion'] ?? ''}',
                          exit['FechaSolicitada'] ?? '',
                          exit['FechaSalida'] ?? '',
                          exit['StatusPermission'] ?? '',
                          exit,
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String formattedDate = DateFormat.yMMMM('es_MX').format(_selectedDate);
    String capitalizedDate = capitalizeFirstLetter(formattedDate);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          capitalizedDate,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateExitScreen(
                  initialDate: _selectedDate,
                ),
              ),
            ).then((value) {
              if (value != null) {
                _addNewExit(value);
                _loadExits(); // Recargar las salidas cuando regresas de la otra pantalla
              }
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            'Nueva Salida',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        locale: 'es',
        initialSelectedDate: _selectedDate,
        selectionColor: Colors.purple,
        selectedTextColor: Colors.white,
        dayTextStyle: const TextStyle(color: Colors.black),
        dateTextStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        monthTextStyle: const TextStyle(color: Colors.black),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar esta salida?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Aprobado':
        return Colors.green;
      case 'Cancelado':
      case 'Rechazado':
        return Colors.red;
      default:
        return Colors.orange; // Pendiente or other statuses
    }
  }

  Widget _buildExitItem(BuildContext context, String title, String date,
      String dateE, String status, Map<String, dynamic> exit) {
    DateTime parsedDate;
    DateTime parsedDateE;
    try {
      parsedDate = DateTime.parse(date);
      parsedDateE = DateTime.parse(dateE);
    } catch (e) {
      return const Text('Fecha inválida');
    }

    String formattedDate =
        DateFormat('dd MMMM yyyy, hh:mm a', 'es_MX').format(parsedDate);

    String formattedDateE =
        DateFormat('dd MMMM yyyy, hh:mm a', 'es_MX').format(parsedDateE);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/exitDetail',
          arguments: {
            'TipoSalida': exit['Descripcion'],
            'NombreUsuario': exit['Nombre'],
            'LugarPartida': exit['MedioSalida'],
            'FechaSalida': exit['FechaSalida'],
            'FechaRegreso': exit['FechaRegreso'],
            'AreaTrabajo': exit['Departamento'],
            'Observaciones': exit['Observaciones'],
            'Motivo': exit['Motivo'],
            'PuntoPartida': exit['PuntoPartida'],
            'Contacto': exit['Celular'],
            'StatusPermission': exit['StatusPermission'],
          },
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          leading: const SizedBox(
            width: 40,
            height: 40,
            child: Icon(Icons.event),
          ),
          title: Text(title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(formattedDateE),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                      color: _getStatusColor(status),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Text(formattedDate)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
