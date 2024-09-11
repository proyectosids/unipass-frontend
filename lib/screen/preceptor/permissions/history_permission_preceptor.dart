import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_unipass/models/permission.dart';
import 'package:flutter_application_unipass/services/authorize_service.dart';
import 'package:flutter_application_unipass/utils/imports.dart';
import 'package:flutter_application_unipass/services/permission_service.dart';
import 'package:flutter_application_unipass/services/register_service.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;

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
  List<Permission> _filteredPermissions = []; // Lista filtrada
  final PermissionService _permissionService =
      PermissionService(RegisterService(), AuthorizeService());

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
          await _permissionService.getPermissionForAutorizacionPrece(matricula);

      permissions.sort((a, b) => b.fechasolicitud.compareTo(a.fechasolicitud));

      setState(() {
        _permissions = permissions;
        _filterPermissionsByDate(
            _selectedDate); // Filtrar inicialmente por la fecha actual
      });
    } catch (e) {
      print('Falla al cargar permisos: $e');
    }
  }

  void _filterPermissionsByDate(DateTime selectedDate) {
    setState(() {
      _filteredPermissions = _permissions.where((permission) {
        return permission.fechasalida.year == selectedDate.year &&
            permission.fechasalida.month == selectedDate.month &&
            permission.fechasalida.day == selectedDate.day;
      }).toList();
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
          'Solicitudes de Salidas',
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
            SizedBox(height: responsive.hp(1)),
            _buildDatePicker(),
            SizedBox(height: responsive.hp(2)),
            const Text(
              'Salidas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: responsive.hp(1.5)),
            Expanded(
              child: _buildPermissionList(), // Usar la lista filtrada aquí
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          capitalizedDate,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(5);
    DateTime currentDate = DateTime.now();
    DateTime startDate =
        currentDate.subtract(const Duration(days: 30)); // 30 días atrás
    DateTime endDate =
        currentDate.add(const Duration(days: 60)); // 60 días adelante

    return Center(
      child: Container(
        padding: EdgeInsets.all(padding),
        width: responsive.wp(100),
        child: dp.DayPicker.single(
          selectedDate: _selectedDate,
          onChanged: (date) {
            setState(() {
              _selectedDate = date;
              _filterPermissionsByDate(
                  _selectedDate); // Filtrar permisos según la fecha seleccionada
            });
          },
          firstDate: startDate,
          lastDate: endDate,
          datePickerStyles: dp.DatePickerRangeStyles(
            selectedDateStyle:
                TextStyle(color: Colors.white, fontSize: responsive.hp(2)),
            selectedSingleDateDecoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            dayHeaderStyle: dp.DayHeaderStyle(
              textStyle:
                  TextStyle(color: Colors.red, fontSize: responsive.hp(2)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionList() {
    if (_filteredPermissions.isEmpty) {
      return const Center(
        child: Text(
          'No hay salidas para la fecha seleccionada',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: _filteredPermissions.length,
      itemBuilder: (context, index) {
        final permission = _filteredPermissions[index];
        return _buildPermissionItem(
          context,
          'SALIDA ${permission.descripcion} DE ${permission.nombre}',
          permission.fechasolicitud.toIso8601String(),
          permission.fechasalida.toIso8601String(),
          permission.statusPermission,
          permission,
        );
      },
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
      case 'Aprobada':
        return Colors.green;
      case 'Cancelado':
      case 'Rechazada':
        return Colors.red;
      default:
        return Colors.orange; // Pendiente o cualquier otro estado
    }
  }

  Widget _buildPermissionItem(BuildContext context, String title, String date,
      String dateE, String status, Permission permission) {
    final Responsive responsive = Responsive.of(context);
    DateTime parsedDate = DateTime.parse(date)
        .subtract(const Duration(hours: 6)); // Restar 6 horas
    DateTime parsedDateE = DateTime.parse(dateE)
        .subtract(const Duration(hours: 6)); // Restar 6 horas

    String formattedDate =
        DateFormat('dd MMMM yyyy, hh:mm a', 'es_MX').format(parsedDate);
    String formattedDateE =
        DateFormat('dd MMMM yyyy, hh:mm a', 'es_MX').format(parsedDateE);

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.pushNamed(
          context,
          '/infoPermission',
          arguments: {
            'IdPermission': permission.id,
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
            'NombreTutor': permission.nombretutor,
            'ApellidosTutor': permission.apellidotutor,
            'ContactoTutor': permission.moviltutor,
            'IdSalida': permission.idsalida,
          },
        );

        if (result == true) {
          _loadPermissions();
        }
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
            overflow: TextOverflow.ellipsis, // Agrega los puntos suspensivos
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
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      status,
                      style: TextStyle(color: _getStatusColor(status)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 25),
                  Flexible(
                    child: Text(
                      formattedDate,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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
