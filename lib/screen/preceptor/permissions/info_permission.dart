import 'package:flutter_application_unipass/models/authorization.dart';
import 'package:flutter_application_unipass/services/auth_service.dart';
import 'package:flutter_application_unipass/services/authorize_service.dart';
import 'package:flutter_application_unipass/services/checks_service.dart';
import 'package:flutter_application_unipass/services/notification_service.dart';
import 'package:flutter_application_unipass/services/permission_service.dart';
import 'package:flutter_application_unipass/services/point_check_service.dart';
import 'package:flutter_application_unipass/services/register_service.dart';
import 'package:flutter_application_unipass/utils/imports.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class InfoPermissionDetail extends StatefulWidget {
  const InfoPermissionDetail({super.key});
  static const routeName = '/infoPermission';

  @override
  State<InfoPermissionDetail> createState() => _InfoPermissionDetailState();
}

class _InfoPermissionDetailState extends State<InfoPermissionDetail> {
  Map<String, dynamic> exitDetails = {};
  bool isFinalized = false;
  String nombreCompleto = '';
  String nombreCompletoTutor = '';
  String valorar = '';
  String? statusPermiso;
  final AuthorizeService _authorizeService = AuthorizeService();
  final PermissionService _permissionService =
      PermissionService(RegisterService(), AuthorizeService(), AuthServices());
  final PointCheckService _pointCheckService = PointCheckService();
  final ChecksService _checksService = ChecksService();
  final AuthServices _authServices = AuthServices();
  String selectedValue = 'Foto no identificable';
  Future<List<Authorization>>? _futureAuthorizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    exitDetails =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    nombreCompleto =
        '${exitDetails['NombreAlumno'] ?? ''} ${exitDetails['ApellidosAlumno'] ?? ''}';
    nombreCompletoTutor =
        '${exitDetails['NombreTutor'] ?? ''} ${exitDetails['ApellidosTutor'] ?? ''}';
    isFinalized = exitDetails['StatusPermission'] == 'Finalizado';
    _loadAuthorize();
  }

  Future<void> _loadAuthorize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? matricula = prefs.getString('matricula');

    if (matricula == null) {
      // ignore: avoid_print
      print('Matricula not found');
      return;
    }

    final idPermiso = exitDetails['IdPermission'] != null
        ? exitDetails['IdPermission'] as int
        : null;

    if (idPermiso == null) {
      // ignore: avoid_print
      print('El idPermiso es null. No se puede obtener el estado del permiso.');
      return;
    }

    statusPermiso = await _authorizeService.obtenerStatus(matricula, idPermiso);

    // Verifica si el widget sigue montado antes de llamar a setState()
    if (mounted) {
      setState(() {});
    }
  }

  Future<List<int>> findEmployeesByDepartments(Set<int> departmentNos) async {
    // Obtener la lista de autorizaciones de manera asíncrona
    List<Authorization>? authorizations = await AuthorizeService()
        .fetchAuthorizations(exitDetails['IdPermission']);

    // Filtrar y encontrar las autorizaciones donde el NoDepto esté en los valores dados
    List<int> employeeIds = [];
    for (var auth in authorizations) {
      if (departmentNos.contains(auth.noDepto)) {
        employeeIds.add(auth.idEmpleado);
      }
    }

    return employeeIds;
  }

  Future<void> _asignarAutorizacion(String autorizo, String motivo) async {
    try {
      final idPermiso = exitDetails['IdPermission'] as int;
      final idSalida = exitDetails['IdSalida'] as int;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? matricula = prefs.getString('matricula');
      String? tipoUser = prefs.getString('tipoUser');
      String? nombre = prefs.getString('nombre');
      String? apellido = prefs.getString('apellidos');
      DateTime fechsalida = DateTime.parse(exitDetails['FechaSalida']);
      String formatoFecha = DateFormat('dd/MM/yyyy').format(fechsalida);

      await _authorizeService.valorarAuthorize(idPermiso, matricula!, autorizo);
///////////////////////////////
      if (autorizo == "Aprobada" && tipoUser == "EMPLEADO" ||
          autorizo == "Aprobada" && tipoUser == "VIGILANCIA") {
        //_futureAuthorizations =
        //  AuthorizeService().fetchAuthorizations(exitDetails['IdPermission']);

        Set<int> departmentsToCheck = {317, 318, 315, 316};
        List<int> employeeIds =
            await findEmployeesByDepartments(departmentsToCheck);
        if (employeeIds.isNotEmpty) {
          int firstEmployeeId =
              employeeIds.first; // Obtiene el primer IdEmpleado de la lista
          String? token = await _authServices.searchTokenFCM(firstEmployeeId
              .toString()); // Asumiendo que la función acepta un String
          String? notificationToken = token; // Obtén el token de alguna manera

          String title = "Solicitud de salida al Pueblo";
          String body =
              "${exitDetails['NombreAlumno']} ${exitDetails['ApellidosAlumno']} ha solicitado una salida para $formatoFecha";
          if (token != null) {
            // Llamada al servicio de notificaciones
            await NotificationService()
                .sendNotificationToServer(notificationToken!, title, body);
            print("Notificación enviada.");
            notificationToken =
                await _authServices.searchTokenFCM(exitDetails['Matricula']);
            title = "Aprobacion de solicitud de jefe de departamento";
            body =
                "Salida ${exitDetails['TipoSalida']} aprobada por $nombre $apellido, pendiente la aprobación de tu preceptor(a)";
            await NotificationService()
                .sendNotificationToServer(notificationToken!, title, body);
          } else {
            print("No se encontró token FCM.");
          }
        } else {
          print(
              "No se encontraron empleados para los departamentos especificados.");
        }
      }

      if (autorizo == 'Rechazada') {
        await _terminarPermiso(autorizo, motivo);
        String? token =
            await _authServices.searchTokenFCM(exitDetails['Matricula']);
        // Supongamos que decides enviar la notificación aquí
        final String? notificationToken =
            token; // Obtén el token de alguna manera
        final String title = _getTitleForIdSalida(idSalida, autorizo);
        final String body =
            "$nombre $apellido ha rechazado su salida por el motivo: $motivo.";
        if (token != null) {
          // Llamada al servicio de notificaciones
          await NotificationService()
              .sendNotificationToServer(notificationToken!, title, body);
          print("Notificación enviada.");
        } else {
          print("No se encontró token FCM.");
        }
      }

      if (autorizo == 'Aprobada' && tipoUser == 'PRECEPTOR') {
        List<dynamic> points = await _pointCheckService.getPoints(idSalida);
        if (points.isNotEmpty) {
          int pointId1 = points[0]['IdPoint'];
          int pointId2 = points[1]['IdPoint'];

          await _checksService.solicitarCreacionChecks(
              idPermiso, 'SALIDA', pointId1);
          await _checksService.solicitarCreacionChecks(
              idPermiso, 'SALIDA', pointId2);
          await _checksService.solicitarCreacionChecks(
              idPermiso, 'RETORNO', pointId2);
          await _checksService.solicitarCreacionChecks(
              idPermiso, 'RETORNO', pointId1);
        } else {
          // ignore: avoid_print
          print('No se encontraron puntos de salida para este permiso.');
        }

        await _terminarPermiso(autorizo, motivo);
        DateTime fechsalida = DateTime.parse(exitDetails['FechaSalida']);
        String formatoFecha = DateFormat('dd/MM/yyyy').format(fechsalida);
        String? token =
            await _authServices.searchTokenFCM(exitDetails['Matricula']);
        // Supongamos que decides enviar la notificación aquí
        final String? notificationToken =
            token; // Obtén el token de alguna manera
        final String title = _getTitleForIdSalida(idSalida, autorizo);
        final String body =
            "$nombre $apellido ha aprobado tu salida con fecha $formatoFecha.";
        if (token != null) {
          // Llamada al servicio de notificaciones
          await NotificationService()
              .sendNotificationToServer(notificationToken!, title, body);
          print("Notificación enviada.");
        } else {
          print("No se encontró token FCM.");
        }
      }

      // Manejando la navegación según el tipo de usuario
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      // ignore: avoid_print
      print('Failed to authorize permission: $e');
    }
  }

  Future<void> _terminarPermiso(String validacion, String razon) async {
    final idPermiso = exitDetails['IdPermission'] as int;
    await _permissionService.terminarPermission(idPermiso, validacion, razon);
  }

  Future<void> _marcaTelefono(Uri phoneNumber) async {
    if (await canLaunchUrl(phoneNumber)) {
      await launchUrl(phoneNumber);
    } else {
      // ignore: avoid_print
      print('No se puede realizar la llamada');
    }
  }

  Future<void> _contactoWhatsApp(Uri whatsApp) async {
    final url = 'https://wa.me/52${exitDetails['ContactoTutor'] ?? ''}';
    print('Intentando abrir WhatsApp con URL: $url');

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print(
          'No se puede abrir WhatsApp. Verifica si está instalado en el dispositivo.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(3);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Detalle del permiso',
          style: TextStyle(
              color: Colors.white,
              fontSize: responsive.dp(2.2),
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromRGBO(6, 66, 106, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(250, 198, 0, 1),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('Alumno', nombreCompleto),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildDetailItem(
                        'Tipo de salida', exitDetails['TipoSalida'] ?? ''),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child:
                        _buildDetailItem('Motivo', exitDetails['Motivo'] ?? ''),
                  ),
                ],
              ),
              _buildDetailItem(
                  'Fecha y hora de salida', exitDetails['FechaSalida'] ?? ''),
              _buildDetailItem(
                  'Fecha y hora de retorno', exitDetails['FechaRegreso'] ?? ''),
              //_buildDetailItem(
              //    'Observaciones', exitDetails['Observaciones'] ?? ''),
              _buildDetailItem(
                  'Contacto Personal', exitDetails['Contacto'] ?? ''),
              _buildDetailItem('Trabajo', exitDetails['Trabajo'] ?? ''),
              _buildDetailItem('Nombre del tutor', nombreCompletoTutor),
              _buildContactSection(exitDetails['ContactoTutor'] ?? 'N/A'),
              SizedBox(height: responsive.hp(1.4)),
              if (statusPermiso == 'Pendiente')
                Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 113, 196, 102),
                        minimumSize: Size(responsive.wp(60), responsive.hp(6)),
                      ),
                      onPressed: () {
                        valorar = "Aprobada";
                        selectedValue = 'Ninguna';
                        _asignarAutorizacion(valorar, selectedValue);
                      },
                      child: const Text(
                        'Aceptar',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),
                      )),
                ),
              const SizedBox(
                height: 10,
              ),
              if (statusPermiso == 'Pendiente')
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 201, 55, 30),
                      minimumSize: Size(responsive.wp(60), responsive.hp(6)),
                    ),
                    onPressed: () {
                      _showRejectDialog(context, responsive);
                    },
                    child: const Text(
                      'Rechazar',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              if (statusPermiso != "Pendiente")
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(250, 198, 0, 1),
                      minimumSize: Size(responsive.wp(60), responsive.hp(6)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cerrar',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showRejectDialog(
      BuildContext context, Responsive responsive) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(responsive.wp(10)), // Bordes redondeados.
        ),
        child: Padding(
          padding: EdgeInsets.all(responsive.wp(5)), // Padding uniforme.
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // La columna se ajusta al tamaño del contenido.
            children: [
              Text(
                'Rechazar Permiso',
                style: TextStyle(
                  fontSize: responsive.dp(2.8), // Tamaño de fuente dinámico.
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: responsive.hp(5)), // Espacio vertical.
              Text(
                '¿Estás seguro de que quieres rechazar este permiso?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: responsive.dp(1.8),
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: responsive.hp(5)),
              _buildRejectDropdown(),

              SizedBox(height: responsive.hp(5)),
              ElevatedButton(
                onPressed: () {
                  valorar = 'Rechazada';
                  _asignarAutorizacion(valorar, selectedValue);

                  Navigator.pop(context, true);
                  //Navigator.of(context).pushNamedAndRemoveUntil(
                  //  '/AuthorizationEmployee',
                  //  (Route<dynamic> route) => false,
                  //);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(double.infinity, responsive.wp(8)), // Tamaño mínimo.
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(
                      vertical: responsive.hp(1.6)), // Padding vertical.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        responsive.wp(30)), // Bordes redondeados del botón.
                  ),
                ),
                child: Text(
                  'Rechazar',
                  style: TextStyle(
                    fontSize: responsive.dp(2), // Tamaño de fuente dinámico.
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: responsive.wp(3)),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // Cierra el diálogo sin realizar acción.
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  minimumSize:
                      Size(double.infinity, responsive.wp(8)), // Tamaño mínimo.
                  padding: EdgeInsets.symmetric(
                      vertical: responsive.hp(1.6)), // Padding vertical.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        responsive.wp(30)), // Bordes redondeados del botón.
                  ),
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    fontSize: responsive.dp(2), // Tamaño de fuente dinámico.
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButtonFormField<String> _buildRejectDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Seleccione un motivo',
        border: OutlineInputBorder(),
      ),
      value:
          selectedValue, // Asegúrate de que este valor inicial esté en la lista de ítems.
      items: <String>[
        'Foto no identificable',
        'Horas pendientes',
        'Indisciplinado',
        'Faltas a culto',
        'Falta de aseo',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue!;
        });
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Debe seleccionar un motivo';
        }
        return null;
      },
    );
  }

  Widget _buildDetailItem(String title, String value) {
    // Intenta parsear el valor como una fecha para formatearla
    String formattedValue = value;
    try {
      DateTime parsedDate = DateTime.parse(value);
      formattedValue =
          DateFormat('dd MMMM yyyy, hh:mm a', 'es_MX').format(parsedDate);
    } catch (e) {
      // Si ocurre un error al parsear, deja el valor como está
      formattedValue = value;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            formattedValue,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const Divider(color: Colors.orange, thickness: 1),
        ],
      ),
    );
  }

  Widget _buildContactSection(String phoneNumber) {
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem('Contacto del tutor', phoneNumber),
        ),
        IconButton(
          icon: const Icon(Icons.phone, color: Colors.green),
          onPressed: () => _marcaTelefono(Uri.parse('tel:$phoneNumber')),
        ),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
          onPressed: () => _contactoWhatsApp(
            Uri.parse('whatsapp://send?phone=52$phoneNumber'),
          ),
        ),
      ],
    );
  }
}

String _getTitleForIdSalida(int idSalida, String valoracion) {
  switch (idSalida) {
    case 1:
      return "Solicitud de Salida al Pueblo $valoracion";
    case 2:
      return "Solicitud de Salida Especial $valoracion";
    case 3:
      return "Solicitud de Salida a Casa $valoracion";
    default:
      return "Solicitud de Salida $valoracion";
  }
}
