import 'package:flutter_application_unipass/services/authorize_service.dart';
import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
import 'package:flutter_application_unipass/utils/imports.dart';

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
  String? statusPermiso;
  final AuthorizeService _authorizeService = AuthorizeService();

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
      print('Matricula not found');
      return;
    }

    final idPermiso = exitDetails['IdPermission'] != null
        ? exitDetails['IdPermission'] as int
        : null;

    if (idPermiso == null) {
      print('El idPermiso es null. No se puede obtener el estado del permiso.');
      return;
    }

    statusPermiso = await _authorizeService.obtenerStatus(matricula, idPermiso);
    setState(() {});
  }

  Future<void> _asignarAutorizacion(String autorizo) async {
    try {
      final idPermiso = exitDetails['IdPermission'] as int;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? matricula = prefs.getString('matricula');

      await _authorizeService.valorarAuthorize(idPermiso, matricula!, autorizo);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      // ignore: avoid_print
      print('Failed to authotize permission: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalle del permiso',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6D55F4),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              _buildDetailItem(
                  'Observaciones', exitDetails['Observaciones'] ?? ''),
              _buildDetailItem(
                  'Contacto Personal', exitDetails['Contacto'] ?? ''),
              _buildDetailItem('Trabajo', exitDetails['Trabajo'] ?? ''),
              _buildDetailItem('Nombre del tutor', nombreCompletoTutor),
              _buildDetailItem(
                  'Contacto del tutor', exitDetails['ContactoTutor'] ?? 'N/A'),
              const SizedBox(height: 20),
              if (statusPermiso == 'Pendiente')
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 113, 196, 102),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      String valorar = "Aprobado";
                      _asignarAutorizacion(valorar);
                    },
                    child: const Text(
                      'Aceptar',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    )),
              const SizedBox(
                height: 10,
              ),
              if (statusPermiso == 'Pendiente')
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 201, 55, 30),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      String valorar = "Rechazado";
                      _asignarAutorizacion(valorar);
                    },
                    child: const Text(
                      'Rechazar',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    )),
              const SizedBox(
                height: 10,
              ),
              if (statusPermiso != "Pendiente")
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA726),
                      minimumSize: const Size(double.infinity, 50),
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

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          //const SizedBox(height: 1),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const Divider(color: Colors.orange, thickness: 1),
        ],
      ),
    );
  }
}
