import 'package:flutter_application_unipass/models/authorization.dart';
import 'package:flutter_application_unipass/services/authorize_service.dart';
import 'package:flutter_application_unipass/utils/imports.dart';
import 'package:intl/intl.dart';

class ExitDetailScreen extends StatefulWidget {
  static const routeName = '/exitDetail';

  const ExitDetailScreen({Key? key}) : super(key: key);

  @override
  _ExitDetailScreenState createState() => _ExitDetailScreenState();
}

class _ExitDetailScreenState extends State<ExitDetailScreen> {
  Future<List<Authorization>>? _futureAuthorizations;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      final Map<String, dynamic> exitDetails =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _futureAuthorizations =
          AuthorizeService().fetchAuthorizations(exitDetails['IdPermission']);
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(5);

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
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color.fromRGBO(6, 66, 106, 1),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Authorization>>(
        future: _futureAuthorizations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return buildContent(snapshot.data!, responsive, padding);
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget buildContent(List<Authorization> authorizations, Responsive responsive,
      double padding) {
    final Map<String, dynamic> exitDetails =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String nombreCompleto =
        '${exitDetails['NombreAlumno'] ?? ''} ${exitDetails['ApellidosAlumno'] ?? ''}';
    bool isFinalized = exitDetails['StatusPermission'] == 'Finalizado';

    return Padding(
      padding: EdgeInsets.all(padding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem(
              'Alumno',
              nombreCompleto,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildDetailItem(
                    'Tipo de salida',
                    exitDetails['TipoSalida'] ?? '',
                  ),
                ),
                SizedBox(width: responsive.wp(4)),
                Expanded(
                  child: _buildDetailItem(
                    'Motivo',
                    exitDetails['Motivo'] ?? '',
                  ),
                ),
              ],
            ),
            _buildDetailItem(
              'Fecha y hora de salida',
              exitDetails['FechaSalida'] ?? '',
            ),
            _buildDetailItem(
              'Fecha y hora de retorno',
              exitDetails['FechaRegreso'] ?? '',
            ),
            _buildDetailItem(
              'Observaciones',
              exitDetails['Observaciones'] ?? '',
            ),
            _buildDetailItem(
              'Contacto Personal',
              exitDetails['Contacto'] ?? '',
            ),
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
            Text(
              'Avance del proceso',
              style: TextStyle(
                  fontSize: responsive.dp(1.8), fontWeight: FontWeight.bold),
            ),
            SizedBox(height: responsive.hp(1.4)),
            _buildDynamicProgressBar(authorizations, responsive),
            SizedBox(height: responsive.hp(1.4)),
            Center(
              child: Text(
                'A la espera para salir de la universidad',
                style: TextStyle(
                    fontSize: responsive.dp(1.5), color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: responsive.hp(1.4)),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(250, 198, 0, 1),
                  minimumSize: Size(responsive.wp(60), responsive.hp(6)),
                ),
                onPressed: () => Navigator.pop(context),
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

  //Widget _buildProgressBar(Responsive responsive, bool isFinalized) {
  //  return Row(
  //    children: [
  //      _buildStepCircle(responsive, '1', isActive: true),
  //      _buildStepLine(isActive: true),
  //      _buildStepCircle(responsive, '2', isActive: isFinalized),
  //      _buildStepLine(isActive: isFinalized),
  //      _buildStepCircle(responsive, '3', isActive: isFinalized),
  //      _buildStepLine(isActive: isFinalized),
  //      _buildStepCircle(responsive, '4', isActive: isFinalized),
  //    ],
  //  );
  //}

  Widget _buildDynamicProgressBar(
      List<Authorization> authorizations, Responsive responsive) {
    // Obtiene los detalles de salida desde los argumentos de la ruta con un casting adecuado
    final Map<String, dynamic> exitDetails =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Lee el tipo de salida desde los detalles de la ruta
    final String tipoSalida = exitDetails['TipoSalida'];

    // Determina cuántos pasos mostrar basado en el tipo de salida
    int numSteps = tipoSalida == 'PUEBLO'
        ? 2
        : authorizations.length; // Asume 2 pasos para 'PUEBLO'

    List<Widget> widgets = [];
    for (int i = 0; i < numSteps; i++) {
      Color color;
      switch (authorizations[i].statusAuthorize) {
        case 'Aprobada':
          color = Colors.green;
          break;
        case 'Rechazada':
          color = Colors.red;
          break;
        default:
          color = Colors.orange; // Considerando como pendiente
      }

      // Agrega el círculo para cada paso
      widgets
          .add(_buildStepCircle(responsive, (i + 1).toString(), color: color));

      // Agrega la línea entre los círculos, excepto después del último
      if (i < numSteps - 1) {
        Color nextColor;
        switch (authorizations[i + 1].statusAuthorize) {
          case 'Aprobada':
            nextColor = Colors.green;
            break;
          case 'Rechazada':
            nextColor = Colors.red;
            break;
          default:
            nextColor = Colors.orange;
        }
        widgets.add(_buildStepLine(color: nextColor));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widgets,
    );
  }

  Widget _buildStepCircle(Responsive responsive, String step,
      {required Color color}) {
    return CircleAvatar(
      radius: responsive.wp(4),
      backgroundColor: color,
      child: Text(
        step,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStepLine({required Color color}) {
    return Expanded(
      child: Container(
        height: 2,
        color: color,
      ),
    );
  }
}
