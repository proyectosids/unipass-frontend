import 'package:flutter_application_unipass/models/permission.dart';
import 'package:flutter_application_unipass/utils/imports.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_unipass/services/permission_service.dart';
import 'package:flutter_application_unipass/services/register_service.dart';

class HistoryPermissionAuthorization extends StatefulWidget {
  static const routeName = '/AuthorizationPreceptor';

  const HistoryPermissionAuthorization({Key? key}) : super(key: key);

  @override
  _HistoryPermissionAuthorizationState createState() =>
      _HistoryPermissionAuthorizationState();
}

class _HistoryPermissionAuthorizationState
    extends State<HistoryPermissionAuthorization> {
  DateTime _selectedDate = DateTime.now();
  List<Permission> _permissions = [];
  final PermissionService _permissionService =
      PermissionService(RegisterService());

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_MX', null);
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? matricula = prefs.getString('matricula');

    if (matricula == null) {
      print('Matricula not found');
      return;
    }

    try {
      List<Permission> permissions =
          await _permissionService.getPermissionForAutorizacion(matricula);

      permissions.sort((a, b) => b.fechasolicitud.compareTo(a.fechasolicitud));

      setState(() {
        _permissions = permissions;
      });
    } catch (e) {
      print('Failed to load permissions: $e');
    }
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
                itemCount: _permissions.length,
                itemBuilder: (context, index) {
                  final permission = _permissions[index];
                  return _buildPermissionItem(
                    context,
                    'SALIDA ${permission.descripcion} DE ${permission.nombre}',
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
              setState(() {
                _permissions.insert(0, result);
              });
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Aprobado':
        return Colors.green;
      case 'Cancelado':
      case 'Rechazado':
        return Colors.red;
      default:
        return Colors.orange; // Pendiente o cualquier otro estado
    }
  }

  Widget _buildPermissionItem(BuildContext context, String title, String date,
      String dateE, String status, Permission permission) {
    DateTime parsedDate = DateTime.parse(date);
    DateTime parsedDateE = DateTime.parse(dateE);

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
          leading: const SizedBox(
            width: 15,
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
                    style: TextStyle(color: _getStatusColor(status)),
                  ),
                  const SizedBox(width: 25),
                  Text(formattedDate),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
