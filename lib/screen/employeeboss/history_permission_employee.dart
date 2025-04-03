import 'package:flutter_application_unipass/services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_unipass/models/permission.dart';
import 'package:flutter_application_unipass/services/authorize_service.dart';
import 'package:flutter_application_unipass/utils/imports.dart';
import 'package:flutter_application_unipass/services/permission_service.dart';
import 'package:flutter_application_unipass/services/register_service.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;

class PermissionAuthorizationEmployee extends StatefulWidget {
  static const routeName = '/AuthorizationEmployee';

  const PermissionAuthorizationEmployee({Key? key}) : super(key: key);

  @override
  _PermissionAuthorizationEmployeeState createState() =>
      _PermissionAuthorizationEmployeeState();
}

class _PermissionAuthorizationEmployeeState
    extends State<PermissionAuthorizationEmployee> {
  DateTime _selectedDate = DateTime.now();
  List<Permission> _permissions = [];
  List<Permission> _filteredPermissions = []; // Lista filtrada
  bool _isLoading = true;
  final PermissionService _permissionService =
      PermissionService(RegisterService(), AuthorizeService(), AuthServices());
  final AuthServices _authService = AuthServices();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_MX', null);
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    setState(() {
      _isLoading = true; // Iniciar la carga
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? matricula = prefs.getString('matricula');

    if (matricula == null) {
      print('Matricula not found');
      setState(() {
        _isLoading = false; // Finalizar la carga en caso de error
      });
      return;
    }

    Map<String, dynamic>? userInfoExt =
        await _authService.UserInfoExt(matricula);
    String? cargoEmp;
    int? activo;
    if (userInfoExt != null) {
      cargoEmp = userInfoExt['MatriculaEncargado'];
      activo = userInfoExt['Activo'];
    } else {
      cargoEmp = '0';
      activo = 0;
    }

    try {
      List<Permission> permissionsEmple =
          await _permissionService.getPermissionForAutorizacion(matricula);

      List<Permission> permissionsAsig = [];
      if (cargoEmp != null && cargoEmp != '0' && activo == 1) {
        permissionsAsig = await _permissionService
            .getPermissionForAutorizacionPrece(cargoEmp);
      }

      List<Permission> permissions = permissionsEmple + permissionsAsig;
      permissions.sort((a, b) => b.fechasolicitud.compareTo(a.fechasolicitud));

      setState(() {
        _permissions = permissions;
        _filterPermissionsByDate(_selectedDate);
        _isLoading = false; // Finalizar carga
      });
    } catch (e) {
      print('Failed to load permissions: $e');
      setState(() {
        _isLoading = false; // Finalizar carga en caso de error
      });
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
        backgroundColor: const Color.fromRGBO(6, 66, 106, 1),
        centerTitle: true,
        title: Text(
          'Solicitudes de Permisos',
          style: TextStyle(
              color: Colors.white,
              fontSize: responsive.dp(2.2),
              fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromRGBO(250, 198, 0, 1)),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/homeEmployeeMenu',
              arguments: 1,
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDatePicker(),
                  const Text(
                    'Salidas',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: responsive.hp(1.5)),
                  SizedBox(
                    height: 400,
                    child: _buildPermissionList(),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
        ],
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
    final double padding = responsive.wp(1);
    DateTime currentDate = DateTime.now();
    DateTime startDate =
        currentDate.subtract(const Duration(days: 30)); // 30 días atrás
    DateTime endDate =
        currentDate.add(const Duration(days: 30)); // 30 días adelante

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
    DateTime parsedDate = DateTime.parse(date);
    DateTime parsedDateE = DateTime.parse(dateE); // Restar 6 horas

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
            'Matricula': permission.matricula,
            'IdLogin': permission.idlogin,
          },
        );

        if (result == true) {
          _loadPermissions();
        }
      },
      child: Card(
        color: Colors.white70,
        shadowColor: Colors.black,
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
