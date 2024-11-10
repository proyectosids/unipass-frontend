import 'package:flutter_application_unipass/utils/imports.dart';

class ExitDetailScreen extends StatefulWidget {
  static const routeName = '/exitDetail';

  const ExitDetailScreen({Key? key}) : super(key: key);

  @override
  _ExitDetailScreenState createState() => _ExitDetailScreenState();
}

class _ExitDetailScreenState extends State<ExitDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> exitDetails =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(5);
    bool isFinalized = exitDetails['StatusPermission'] == 'Finalizado';

    String nombreCompleto =
        '${exitDetails['NombreAlumno'] ?? ''} ${exitDetails['ApellidosAlumno'] ?? ''}';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Detalle salida',
          style: TextStyle(
              color: const Color.fromRGBO(189, 188, 188, 1),
              fontSize: responsive.dp(2.2),
              fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(250, 198, 0, 1),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromRGBO(6, 66, 106, 1),
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
                  SizedBox(width: responsive.wp(4)),
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
              SizedBox(height: responsive.hp(1.4)),
              Text(
                'Estatus',
                style: TextStyle(
                    fontSize: responsive.dp(1.8), fontWeight: FontWeight.bold),
              ),
              SizedBox(height: responsive.hp(1.4)),
              Center(
                child: Chip(
                  label: Text(exitDetails['StatusPermission'] ?? ''),
                  backgroundColor:
                      _getStatusColor(exitDetails['StatusPermission']),
                  labelStyle: TextStyle(
                      color: Colors.white, fontSize: responsive.dp(1.6)),
                ),
              ),
              SizedBox(height: responsive.hp(1.4)),
              //Text(
              //  'Avance del proceso',
              //  style: TextStyle(
              //      fontSize: responsive.dp(1.8), fontWeight: FontWeight.bold),
              //),
              //SizedBox(height: responsive.hp(1.4)),
              //_buildProgressBar(responsive, isFinalized),
              //SizedBox(height: responsive.hp(1.4)),
              //Center(
              //  child: Text(
              //    'A la espera para salir de la universidad',
              //    style: TextStyle(
              //        fontSize: responsive.dp(1.5), color: Colors.grey[600]),
              //  ),
              //),
              SizedBox(height: responsive.hp(1.4)),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(250, 198, 0, 1),
                    minimumSize: Size(responsive.wp(60), responsive.hp(6)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cerrar',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: responsive.dp(1.9)),
                  ),
                ),
              ),
              SizedBox(height: responsive.hp(1)),
            ],
          ),
        ),
      ),
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
        return Colors.orange; // Pendiente u otros estados
    }
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
          const SizedBox(height: 1),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const Divider(color: Colors.orange, thickness: 1),
        ],
      ),
    );
  }

  Widget _buildProgressBar(Responsive responsive, bool isFinalized) {
    return Row(
      children: [
        _buildStepCircle(responsive, '1', isActive: true),
        _buildStepLine(isActive: true),
        _buildStepCircle(responsive, '2', isActive: isFinalized),
        _buildStepLine(isActive: isFinalized),
        _buildStepCircle(responsive, '3', isActive: isFinalized),
        _buildStepLine(isActive: isFinalized),
        _buildStepCircle(responsive, '4', isActive: isFinalized),
      ],
    );
  }

  Widget _buildStepCircle(Responsive responsive, String step,
      {required bool isActive}) {
    return CircleAvatar(
      radius: responsive.wp(4),
      backgroundColor:
          isActive ? const Color.fromRGBO(182, 217, 59, 1) : Colors.grey,
      child: Text(
        step,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStepLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? const Color.fromRGBO(182, 217, 59, 1) : Colors.grey,
      ),
    );
  }
}
