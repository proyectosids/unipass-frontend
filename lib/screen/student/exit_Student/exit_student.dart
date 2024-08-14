import 'package:flutter_application_unipass/models/permission.dart';
import 'package:flutter_application_unipass/services/auth_service.dart';
import 'package:flutter_application_unipass/services/authorize_service.dart';
import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
import 'package:flutter_application_unipass/utils/imports.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_unipass/services/permission_service.dart';
import 'package:flutter_application_unipass/services/register_service.dart';

class ExitStudent extends StatefulWidget {
  static const routeName = '/ExitStudent';

  const ExitStudent({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ExitStudentState createState() => _ExitStudentState();
}

class _ExitStudentState extends State<ExitStudent> {
  DateTime _selectedDate = DateTime.now();
  List<Permission> _permissions = [];
  final PermissionService _permissionService =
      PermissionService(RegisterService(), AuthorizeService());
  String? matricula;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_MX', null);
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    int? id = await AuthUtils.getUserId();
    if (id == null) {
      print('User ID not found');
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    matricula = prefs.getString('matricula');

    if (matricula == null) {
      print('Matricula not found');
      return;
    }

    try {
      List<Permission> permissions =
          await _permissionService.getPermissions(id, matricula!);

      // Imprimir los permisos para depuración
      permissions.forEach((permission) {
        print(
            'Permission: ${permission.descripcion}, ${permission.fechasolicitud}');
      });

      // Ordenar los permisos por fecha, asegurándose de que el más reciente esté primero
      permissions.sort((a, b) => b.fechasolicitud.compareTo(a.fechasolicitud));

      setState(() {
        _permissions = permissions;
      });
    } catch (e) {
      print('Failed to load permissions: $e');
    }
  }

  Future<void> _cancelPermission(int id) async {
    try {
      await _permissionService.cancelPermission(id);
      await _loadPermissions(); // Recargar las salidas después de cancelar
    } catch (e) {
      print('Failed to cancel permission: $e');
    }
  }

  void _addNewPermission(Permission newPermission) {
    setState(() {
      _permissions.insert(0, newPermission);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(3);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Salidas',
          style: TextStyle(fontSize: responsive.dp(2.5)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(padding),
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
                itemCount: _permissions.length,
                itemBuilder: (context, index) {
                  final permission = _permissions[index];
                  return permission.statusPermission == 'Pendiente'
                      ? Dismissible(
                          key: Key(permission.id.toString()),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await _showConfirmationDialog(context);
                          },
                          onDismissed: (direction) {
                            _cancelPermission(permission.id);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: _buildPermissionItem(
                            context,
                            'SALIDA ${permission.descripcion}',
                            permission.fechasolicitud.toIso8601String(),
                            permission.fechasalida.toIso8601String(),
                            permission.statusPermission,
                            permission,
                          ),
                        )
                      : _buildPermissionItem(
                          context,
                          'SALIDA ${permission.descripcion}',
                          permission.fechasolicitud.toIso8601String(),
                          permission.fechasalida.toIso8601String(),
                          permission.statusPermission,
                          permission,
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
            );

            if (result != null && result is Permission) {
              _addNewPermission(result);
              _loadPermissions(); // Recargar las salidas cuando regresas de la otra pantalla
            }
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

  Widget _buildPermissionItem(BuildContext context, String title, String date,
      String dateE, String status, Permission permission) {
    final Responsive responsive = Responsive.of(context);
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
            'TipoSalida': permission.descripcion,
            'NombreAlumno': permission.nombre,
            'ApellidosAlumno': permission.apellidos,
            'FechaSalida': permission.fechasalida.toIso8601String(),
            'FechaRegreso': permission.fecharegreso.toIso8601String(),
            'Observaciones': permission.observaciones,
            'Motivo': permission.motivo,
            'Contacto': permission.celular,
            'StatusPermission': permission.statusPermission,
            'Trabajo': permission.trabajo,
          },
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          leading: SizedBox(
            width: responsive.wp(5),
            height: responsive.hp(20),
            child: const Icon(Icons.event),
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: responsive.dp(1.5)),
          ),
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
