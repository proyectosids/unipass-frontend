import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/utils/imports.dart';

class ExitDetailScreen extends StatelessWidget {
  static const routeName = '/exitDetail';

  const ExitDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> exitDetails =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Responsive responsive = Responsive.of(context);

    bool isFinalized = exitDetails['StatusPermission'] == 'Finalizado';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalle salida',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF6D55F4),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: _buildDetailItem(
                          'Tipo de salida', exitDetails['TipoSalida'])),
                  SizedBox(width: 16),
                  Expanded(
                      child: _buildDetailItem(
                          'Usuario', exitDetails['NombreUsuario'])),
                ],
              ),
              _buildDetailItem('Lugar de partida', exitDetails['LugarPartida']),
              _buildDetailItem(
                  'Fecha y hora de salida', exitDetails['FechaSalida']),
              _buildDetailItem(
                  'Fecha y hora de retorno', exitDetails['FechaRegreso']),
              _buildDetailItem('Área de trabajo', exitDetails['AreaTrabajo']),
              _buildDetailItem('Observaciones', exitDetails['Observaciones']),
              _buildDetailItem('Motivo', exitDetails['Motivo']),
              _buildDetailItem('Punto de partida', exitDetails['PuntoPartida']),
              _buildDetailItem('Contacto', exitDetails['Contacto']),
              SizedBox(height: 10),
              Text(
                'Estatus',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Center(
                child: Chip(
                  label: Text(exitDetails['StatusPermission']),
                  backgroundColor:
                      _getStatusColor(exitDetails['StatusPermission']),
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Avance del proceso',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildProgressBar(responsive, isFinalized),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'A la espera para salir de la universidad',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFA726),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Aprobado':
        return Colors.green;
      case 'Cancelado':
      case 'Rechazado':
        return Colors.red;
      default:
        return Colors.orange; // Pendiente or other statuses
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Divider(color: Colors.orange, thickness: 1),
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
      backgroundColor: isActive ? Color.fromRGBO(182, 217, 59, 1) : Colors.grey,
      child: Text(
        step,
        style: TextStyle(
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
        color: isActive ? Color.fromRGBO(182, 217, 59, 1) : Colors.grey,
      ),
    );
  }
}
