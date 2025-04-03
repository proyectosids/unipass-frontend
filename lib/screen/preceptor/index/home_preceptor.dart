import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/models/permission.dart';
import 'package:flutter_application_unipass/services/auth_service.dart';
import 'package:flutter_application_unipass/services/authorize_service.dart';
import 'package:flutter_application_unipass/services/permission_service.dart';
import 'package:flutter_application_unipass/services/register_service.dart';
import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
import 'package:flutter_application_unipass/utils/imports.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePreceptorScreen extends StatefulWidget {
  static const routeName = '/homePreceptor';

  const HomePreceptorScreen({Key? key}) : super(key: key);

  @override
  State<HomePreceptorScreen> createState() => _HomePreceptorScreenState();
}

class _HomePreceptorScreenState extends State<HomePreceptorScreen> {
  String? nombre;
  String? apellidos;
  bool isLoading = true;
  List<Permission> permissions = [];

  final permissionService = PermissionService(
    RegisterService(),
    AuthorizeService(),
    AuthServices(),
  );

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_MX', null);
    _loadUserAndPermissions();
  }

  Future<void> _loadUserAndPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final nombreUsuario = prefs.getString('nombre');
    final apellidosUsuario = prefs.getString('apellidos');

    setState(() {
      nombre = nombreUsuario;
      apellidos = apellidosUsuario;
    });

    try {
      final result = await permissionService.getTopPermissionsByPreceptor();
      setState(() {
        permissions = result;
      });
    } catch (e) {
      print('Error al obtener permisos del preceptor: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Bienvenido, ${nombre ?? 'Preceptor'}',
              style: TextStyle(
                fontSize: responsive.dp(2.2),
                fontFamily: 'Roboto',
              ),
            ),
            if (apellidos != null)
              Text(
                apellidos!,
                style: TextStyle(
                    fontSize: responsive.dp(1.4),
                    color: const Color.fromARGB(255, 138, 138, 138)),
              ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : permissions.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Bienvenido a tu panel de Preceptor',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Aquí podrás monitorear las últimas salidas de tus estudiantes.',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Solicitudes recientes',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context,
                                  HistoryPermissionAuthorization.routeName);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(6, 66, 106, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Ir a Salidas',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh:
                            _loadUserAndPermissions, // Recarga cuando se desliza hacia abajo
                        child: ListView.builder(
                          physics:
                              const AlwaysScrollableScrollPhysics(), // Asegura que funcione el gesto
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: permissions.length,
                          itemBuilder: (context, index) {
                            final p = permissions[index];
                            return _buildPermissionItem(
                              context,
                              p.motivo,
                              p.fechasolicitud.toIso8601String(),
                              p.fechasalida.toIso8601String(),
                              p.statusPermission,
                              p,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    );
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
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedDateE,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: responsive.hp(0.3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _getStatusColor(status),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: responsive.wp(0.5)),
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

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'aprobada':
      return Colors.green;
    case 'rechazada':
      return Colors.red;
    case 'pendiente':
      return Colors.orange;
    case 'cancelado':
      return Colors.grey;
    default:
      return Colors.black;
  }
}
