import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/screen/student/exit_Student/create_exit.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_unipass/models/permission.dart';
import 'package:flutter_application_unipass/services/authorize_service.dart';
import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
import 'package:flutter_application_unipass/services/permission_service.dart';
import 'package:flutter_application_unipass/services/register_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';

class ExitStudent extends StatefulWidget {
  static const routeName = '/ExitStudent';

  const ExitStudent({Key? key}) : super(key: key);

  @override
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

  // Función para verificar si la fecha seleccionada está dentro de los próximos 7 días
  bool _isDateWithin7Days() {
    final now = DateTime.now();
    final difference = _selectedDate.difference(now).inDays;
    return difference <= 7;
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(3);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(6, 66, 106, 1),
        centerTitle: true,
        title: Text(
          'Salidas',
          style: TextStyle(
              color: Colors.white,
              fontSize: responsive.dp(2.2),
              fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromRGBO(250, 198, 0, 1)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Agregar scroll
        child: Padding(
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
              // Aquí está el ListView.builder
              ListView.builder(
                shrinkWrap:
                    true, // Permite que el ListView se ajuste al contenido
                physics:
                    const NeverScrollableScrollPhysics(), // Desactiva el scroll interno
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String formattedDate = DateFormat.yMMMM('es_MX').format(_selectedDate);
    String capitalizedDate = capitalizeFirstLetter(formattedDate);
    final Responsive responsive = Responsive.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          capitalizedDate,
          style: TextStyle(
              fontSize: responsive.dp(2.4), fontWeight: FontWeight.bold),
          overflow: TextOverflow
              .ellipsis, // Añadir truncamiento con puntos suspensivos
          maxLines: 1,
        ),
        ElevatedButton(
          onPressed: _isDateWithin7Days()
              ? () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateExitScreen(
                        initialDate:
                            _selectedDate, // Pasar la fecha seleccionada
                      ),
                    ),
                  );

                  if (result != null && result is Permission) {
                    _addNewPermission(result);
                    _loadPermissions(); // Recargar las salidas cuando regresas de la otra pantalla
                  }
                }
              : null, // Deshabilita el botón si la fecha no es válida
          style: ElevatedButton.styleFrom(
            backgroundColor: _isDateWithin7Days()
                ? Color.fromRGBO(6, 66, 106, 1)
                : Colors.grey, // Cambia el color si está deshabilitado
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
        selectionColor: Color.fromRGBO(6, 66, 106, 1),
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
    final Responsive responsive = Responsive.of(context);
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(responsive.wp(10))),
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
      case 'Aprobada':
        return Colors.green;
      case 'Cancelado':
      case 'Rechazada':
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
      parsedDate = DateTime.parse(date)
          .subtract(const Duration(hours: 6)); // Restar 6 horas
      parsedDateE = DateTime.parse(dateE)
          .subtract(const Duration(hours: 6)); // Restar 6 horas
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
        color: Colors.white70,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          leading: SizedBox(
            width: responsive.wp(5),
            height: responsive.hp(10),
            child: const Icon(Icons.event),
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: responsive.dp(1.5)),
            overflow: TextOverflow
                .ellipsis, // Añadir truncamiento con puntos suspensivos
            maxLines: 1, // Limitar a 1 línea
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedDateE,
                overflow: TextOverflow.ellipsis, // Puntos suspensivos si excede
                maxLines: 1, // Limitar a 1 línea
              ),
              SizedBox(height: responsive.hp(0.3)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    // Evita que el texto se desborde en la fila
                    child: Text(
                      status,
                      style: TextStyle(
                        color: _getStatusColor(status),
                      ),
                      overflow: TextOverflow
                          .ellipsis, // Añadir truncamiento con puntos suspensivos
                      maxLines: 1, // Limitar a 1 línea
                    ),
                  ),
                  SizedBox(
                    width: responsive.wp(0.5),
                  ),
                  Flexible(
                    // Evita que el texto se desborde en la fila
                    child: Text(
                      formattedDate,
                      overflow: TextOverflow
                          .ellipsis, // Añadir truncamiento con puntos suspensivos
                      maxLines: 1, // Limitar a 1 línea
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
