import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/models/paginated_permissions.dart';
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
  bool _isLoading = true; // Estado de carga
  bool _isLoadingMore = false; // Estado de carga adicional para paginación
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_MX', null);
    _loadPermissions();

    // Detecta cuando el usuario llega al final de la lista
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_isLoadingMore &&
          _currentPage < _totalPages) {
        _loadMorePermissions();
      }
    });
  }

  Future<void> _loadPermissions() async {
    setState(() {
      _isLoading = true; // Inicia la pantalla de carga
    });

    int? id = await AuthUtils.getUserId();
    if (id == null) {
      print('User ID not found');
      setState(() {
        _isLoading = false; // Desactiva la pantalla de carga si falla
      });
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    matricula = prefs.getString('matricula');

    if (matricula == null) {
      print('Matricula not found');
      setState(() {
        _isLoading = false; // Desactiva la pantalla de carga si falla
      });
      return;
    }

    try {
      PaginatedPermissions paginatedPermissions = await _permissionService
          .getPermissions(id, matricula!, page: _currentPage);

      setState(() {
        _permissions = paginatedPermissions.permissions;
        _totalPages = paginatedPermissions.totalPages;
        _isLoading =
            false; // Desactiva la pantalla de carga cuando se completan los datos
      });
    } catch (e) {
      print('Failed to load permissions: $e');
      setState(() {
        _isLoading = false; // Desactiva la pantalla de carga si hay un error
      });
    }
  }

  Future<void> _loadMorePermissions() async {
    if (_currentPage >= _totalPages) return;

    setState(() {
      _isLoadingMore = true; // Inicia la pantalla de carga para más permisos
    });

    _currentPage += 1;

    try {
      int? id = await AuthUtils.getUserId();
      if (id == null) return;

      PaginatedPermissions paginatedPermissions = await _permissionService
          .getPermissions(id, matricula!, page: _currentPage);

      setState(() {
        _permissions.addAll(paginatedPermissions.permissions);
        _isLoadingMore =
            false; // Desactiva la carga adicional después de agregar más permisos
      });
    } catch (e) {
      print('Failed to load more permissions: $e');
      setState(() {
        _isLoadingMore =
            false; // Desactiva la pantalla de carga si hay un error
      });
    }
  }

  Future<void> _cancelPermission(int id) async {
    int? userId = await AuthUtils.getUserId();
    if (userId == null) {
      print('User ID not found');
      return;
    }

    try {
      await _permissionService.cancelPermission(id, userId);
      await _loadPermissions(); // Recargar permisos después de la cancelación
    } catch (e) {
      print('Failed to cancel permission: $e');
    }
  }

  void _addNewPermission(Permission newPermission) {
    setState(() {
      _permissions.insert(0, newPermission);
    });
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: _scrollController,
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
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _permissions.length + 1,
                      itemBuilder: (context, index) {
                        if (index < _permissions.length) {
                          final permission = _permissions[index];
                          return permission.statusPermission == 'Pendiente'
                              ? Dismissible(
                                  key: Key(permission.id.toString()),
                                  direction: DismissDirection.endToStart,
                                  confirmDismiss: (direction) async {
                                    return await _showConfirmationDialog(
                                        context);
                                  },
                                  onDismissed: (direction) {
                                    _cancelPermission(permission.id);
                                  },
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: const Icon(Icons.delete,
                                        color: Colors.white),
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
                        } else {
                          return _isLoadingMore
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : const SizedBox.shrink();
                        }
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
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        ElevatedButton(
          onPressed: _isDateWithin7Days()
              ? () async {
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
                    _loadPermissions();
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isDateWithin7Days()
                ? const Color.fromRGBO(6, 66, 106, 1)
                : Colors.grey,
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
        selectionColor: const Color.fromRGBO(6, 66, 106, 1),
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
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive.wp(10)),
          ),
          child: Padding(
            padding: EdgeInsets.all(responsive.wp(5)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Confirmación',
                  style: TextStyle(
                    fontSize: responsive.dp(2.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: responsive.hp(5)),
                Text(
                  '¿Estás seguro de que deseas eliminar esta salida?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: responsive.dp(1.8),
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: responsive.hp(5)),
                SizedBox(
                  width: responsive.wp(80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: responsive.wp(30), // Ancho del botón "Cancelar"
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(
                                vertical: responsive.hp(1.6)),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(responsive.wp(30)),
                            ),
                          ),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              fontSize: responsive.dp(2),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: responsive.wp(5)),
                      SizedBox(
                        width: responsive.wp(30), // Ancho del botón "Salir"
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(250, 198, 0, 1),
                            padding: EdgeInsets.symmetric(
                                vertical: responsive.hp(1.6)),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(responsive.wp(30)),
                            ),
                          ),
                          child: Text(
                            'Eliminar',
                            style: TextStyle(
                              fontSize: responsive.dp(2),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
