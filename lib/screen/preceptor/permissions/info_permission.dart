import 'package:flutter_application_unipass/services/authorize_service.dart';
import 'package:flutter_application_unipass/services/permission_service.dart';
import 'package:flutter_application_unipass/services/register_service.dart';
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
  String valorar = '';
  String? statusPermiso;
  final AuthorizeService _authorizeService = AuthorizeService();
  final PermissionService _permissionService =
      PermissionService(RegisterService(), AuthorizeService());
  String selectedValue = 'Foto no identificable';

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

    // Verifica si el widget sigue montado antes de llamar a setState()
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _asignarAutorizacion(String autorizo, String motivo) async {
    try {
      final idPermiso = exitDetails['IdPermission'] as int;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? matricula = prefs.getString('matricula');
      String? tipoUser = prefs.getString('tipoUser');

      await _authorizeService.valorarAuthorize(idPermiso, matricula!, autorizo);
      if (autorizo == 'Rechazada') {
        _terminarPermiso(autorizo, motivo);
      }

      if (autorizo == 'Aprobada' && tipoUser == 'PRECEPTOR') {
        _terminarPermiso(autorizo, motivo);
      }

      if (mounted && tipoUser == 'PRECEPTOR') {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/AuthorizationPreceptors',
          (Route<dynamic> route) => false,
        );
      }
      if (mounted && tipoUser == 'EMPLEADO') {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/AuthorizationEmployee',
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print('Failed to authotize permission: $e');
    }
  }

  Future<void> _terminarPermiso(String validacion, String razon) async {
    final idPermiso = exitDetails['IdPermission'] as int;
    await _permissionService.terminarPermission(idPermiso, validacion, razon);
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalle del permiso',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6D55F4),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
              //_buildDetailItem(
              //    'Observaciones', exitDetails['Observaciones'] ?? ''),
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
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              responsive.wp(10)), // Bordes redondeados.
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                              responsive.wp(5)), // Padding uniforme.
                          child: Column(
                            mainAxisSize: MainAxisSize
                                .min, // La columna se ajusta al tamaño del contenido.
                            children: [
                              Text(
                                'Rechazar Permiso',
                                style: TextStyle(
                                  fontSize: responsive
                                      .dp(2.8), // Tamaño de fuente dinámico.
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                  height:
                                      responsive.hp(5)), // Espacio vertical.
                              Text(
                                '¿Estás seguro de que quieres rechazar este permiso?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: responsive.dp(1.8),
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: responsive.hp(5)),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
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
                              ),

                              SizedBox(height: responsive.hp(5)),
                              ElevatedButton(
                                onPressed: () {
                                  valorar = 'Rechazada';
                                  _asignarAutorizacion(valorar, selectedValue);

                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/AuthorizationEmployee',
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity,
                                      responsive.wp(8)), // Tamaño mínimo.
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(
                                      vertical: responsive
                                          .hp(1.6)), // Padding vertical.
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        responsive.wp(
                                            30)), // Bordes redondeados del botón.
                                  ),
                                ),
                                child: Text(
                                  'Rechazar',
                                  style: TextStyle(
                                    fontSize: responsive
                                        .dp(2), // Tamaño de fuente dinámico.
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: responsive.wp(3)),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      false); // Cierra el diálogo sin realizar acción.
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  minimumSize: Size(double.infinity,
                                      responsive.wp(8)), // Tamaño mínimo.
                                  padding: EdgeInsets.symmetric(
                                      vertical: responsive
                                          .hp(1.6)), // Padding vertical.
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        responsive.wp(
                                            30)), // Bordes redondeados del botón.
                                  ),
                                ),
                                child: Text(
                                  'Cancelar',
                                  style: TextStyle(
                                    fontSize: responsive
                                        .dp(2), // Tamaño de fuente dinámico.
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Rechazar',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
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
