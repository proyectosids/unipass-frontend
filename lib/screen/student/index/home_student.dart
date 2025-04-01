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

class HomeStudentScreen extends StatefulWidget {
  static const routeName = '/homeStudent';

  const HomeStudentScreen({Key? key}) : super(key: key);

  @override
  State<HomeStudentScreen> createState() => _HomeStudentScreenState();
}

class _HomeStudentScreenState extends State<HomeStudentScreen> {
  String? nombre;
  String? apellidos;
  int? userId;
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
    final idLogin = await AuthUtils.getUserId();

    setState(() {
      nombre = nombreUsuario;
      apellidos = apellidosUsuario;
      userId = idLogin;
    });

    if (idLogin != null) {
      try {
        final result = await permissionService.getTopPermissionsByUser(idLogin);
        setState(() {
          permissions = result;
        });
      } catch (e) {
        print('Error al obtener permisos: $e');
      }
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
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Bienvenido, ${nombre ?? 'Alumno'}',
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
                          'Bienvenido a tu aplicación UNIPASS',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Esperamos que esta aplicación pueda ser de beneficio\nDisfrútala',
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Salidas recientes',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //ElevatedButton(
                            //  onPressed: () {
                            //    Navigator.pushNamed(
                            //        context, ExitStudent.routeName);
                            //  },
                            //  style: ElevatedButton.styleFrom(
                            //    backgroundColor: Color.fromRGBO(6, 66, 106, 1),
                            //    shape: RoundedRectangleBorder(
                            //      borderRadius: BorderRadius.circular(8),
                            //    ),
                            //  ),
                            //  child: const Text(
                            //    'Ir a Salidas',
                            //    style: TextStyle(
                            //      color: Colors.white,
                            //      fontWeight: FontWeight.bold,
                            //    ),
                            //  ),
                            //),
                          ]),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: permissions.length,
                        itemBuilder: (context, index) {
                          final p = permissions[index];
                          return _buildPermissionItem(
                            context,
                            p.motivo,
                            p.fechasalida.toIso8601String(),
                            p.fecharegreso.toIso8601String(),
                            p.statusPermission,
                            p,
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}

String formatDateTime12H(DateTime dateTime) {
  final formatter = DateFormat('dd MMM yyyy, hh:mm a', 'es_MX');
  return formatter.format(dateTime);
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
