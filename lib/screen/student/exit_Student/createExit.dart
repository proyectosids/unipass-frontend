import 'package:flutter_application_unipass/utils/imports.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_unipass/services/permission_service.dart';
import 'package:flutter_application_unipass/utils/auth_utils.dart';

class CreateExitScreen extends StatefulWidget {
  static const routeName = '/createExit';
  final DateTime initialDate;

  const CreateExitScreen({Key? key, required this.initialDate})
      : super(key: key);

  @override
  _CreateExitScreenState createState() => _CreateExitScreenState();
}

class _CreateExitScreenState extends State<CreateExitScreen> {
  late DateTime _selectedStartDate;
  late DateTime _selectedEndDate;
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay(
    hour: (TimeOfDay.now().hour + 4) % 24,
    minute: TimeOfDay.now().minute,
  );
  String _selectedReason = 'Compras';
  String _selectedTransport = 'En vehiculo';
  String _selectedType = 'Pueblo';
  final PermissionService _permissionService = PermissionService();
  final Map<String, int> typeMap = {
    'Pueblo': 1,
    'Especial': 2,
    'A casa': 3,
  };

  @override
  void initState() {
    super.initState();
    _selectedStartDate = widget.initialDate;
    _selectedEndDate = _selectedStartDate.add(Duration(hours: 4));
  }

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    if (_selectedType == 'Pueblo' && !isStart) {
      // No hacer nada si el tipo es 'Pueblo' y no es la hora de salida
      return;
    }

    if (_selectedType == 'Pueblo') {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: isStart ? _selectedStartTime : _selectedEndTime,
      );

      if (pickedTime != null) {
        setState(() {
          if (isStart) {
            _selectedStartTime = pickedTime;
            _selectedEndTime = TimeOfDay(
              hour: (pickedTime.hour + 4) % 24,
              minute: pickedTime.minute,
            );
          } else {
            _selectedEndTime = pickedTime;
          }
        });
      }
    } else {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: isStart ? _selectedStartDate : _selectedEndDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );

      if (pickedDate != null) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: isStart ? _selectedStartTime : _selectedEndTime,
        );

        if (pickedTime != null) {
          setState(() {
            if (isStart) {
              _selectedStartDate = pickedDate;
              _selectedStartTime = pickedTime;
              _selectedEndDate = pickedDate;
              _selectedEndTime = TimeOfDay(
                hour: (pickedTime.hour + 4) % 24,
                minute: pickedTime.minute,
              );
            } else {
              _selectedEndDate = pickedDate;
              _selectedEndTime = pickedTime;
            }
          });
        }
      }
    }
  }

  String _formatDateTime(DateTime date, TimeOfDay time) {
    final DateTime dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateFormat timeFormat = DateFormat('hh:mm a'); // Formato de 12 horas
    return '${dateFormat.format(dateTime)} ${timeFormat.format(dateTime)}';
  }

  Future<void> _createExit() async {
    int? userId = await AuthUtils.getUserId();
    if (userId == null) {
      print('User ID not found');
      return;
    }

    final newExit = {
      'FechaSolicitada': DateTime.now().toIso8601String(),
      'StatusPermission': 'Pendiente',
      'FechaSalida': _selectedStartDate.toIso8601String(),
      'FechaRegreso': _selectedEndDate.toIso8601String(),
      'Motivo': _selectedReason,
      'MedioSalida': _selectedTransport,
      'Tipo': _selectedType,
      'IdUsuario': userId,
      'IdTipoSalida': typeMap[_selectedType],
    };

    try {
      final result = await _permissionService.createPermission(newExit);
      Navigator.pop(context, {
        'title': 'Salida ${result['Tipo']}',
        'date': 'el ${_formatDateTime(_selectedStartDate, _selectedStartTime)}',
        'status': result['StatusPermission'],
        'detail': 'Detalles de la nueva salida'
      });
    } catch (e) {
      print('Failed to create exit: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crear salida',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF6D55F4),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tipo de salida',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildChoiceChip('Pueblo'),
                _buildChoiceChip('Especial'),
                _buildChoiceChip('A casa'),
              ],
            ),
            SizedBox(height: 20),
            _buildDateTimePicker('Fecha y hora de salida', _selectedStartDate,
                _selectedStartTime, true),
            SizedBox(height: 20),
            _buildDateTimePicker('Fecha y hora de retorno', _selectedEndDate,
                _selectedEndTime, false,
                enabled: _selectedType != 'Pueblo'),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedReason,
              decoration: const InputDecoration(labelText: 'Motivo'),
              items: <String>['Compras', 'Trabajo', 'Ocio', 'Otros']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedReason = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Medio por el cual saldrás',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTransportChip('Caminando'),
                _buildTransportChip('En vehiculo'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFA726),
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: _createExit,
              child: Text(
                'Crear salida',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedType == label,
      onSelected: (bool selected) {
        setState(() {
          _selectedType = label;
        });
      },
      selectedColor: Color.fromRGBO(182, 217, 59, 1),
    );
  }

  Widget _buildTransportChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedTransport == label,
      onSelected: (bool selected) {
        setState(() {
          _selectedTransport = label;
        });
      },
      selectedColor: Color.fromRGBO(182, 217, 59, 1),
    );
  }

  Widget _buildDateTimePicker(
      String label, DateTime date, TimeOfDay time, bool isStart,
      {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        InkWell(
          onTap: enabled ? () => _selectDateTime(context, isStart) : null,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(10),
              enabled: enabled,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDateTime(date, time),
                  style: TextStyle(color: enabled ? Colors.black : Colors.grey),
                ),
                Icon(Icons.calendar_today,
                    color: enabled ? Colors.black : Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
