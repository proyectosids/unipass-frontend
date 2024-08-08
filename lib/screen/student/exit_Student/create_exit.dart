import 'package:flutter_application_unipass/utils/imports.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_unipass/services/permission_service.dart';
import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/services/auth_service.dart';
import 'package:flutter_application_unipass/models/permission.dart';
import 'package:flutter_application_unipass/services/register_service.dart';

class CreateExitScreen extends StatefulWidget {
  static const routeName = '/createExit';
  final DateTime initialDate;

  const CreateExitScreen({Key? key, required this.initialDate})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
  String _selectedType = '';
  final PermissionService _permissionService =
      PermissionService(RegisterService());
  final Map<String, int> typeMap = {
    'Pueblo': 1,
    'Especial': 2,
    'A casa': 3,
  };

  @override
  void initState() {
    super.initState();
    _selectedStartDate = widget.initialDate;
    _selectedEndDate = _selectedStartDate.add(const Duration(hours: 4));
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

  Future<void> _createExit(BuildContext context) async {
    int? userId = await AuthUtils.getUserId();
    if (userId == null) {
      print('User ID not found');
      return;
    }

    Map<String, dynamic>? userInfo = await getUserInfo(userId);
    if (userInfo == null) {
      print('User info not found');
      return;
    }

    String userSex = userInfo['Sexo'] ?? ''; // Manejo de posibles valores null
    // Validar el día según el sexo, solo si el tipo de salida es 'Pueblo'
    if (_selectedType == 'Pueblo' &&
        !_isValidDayForSex(userSex, _selectedStartDate)) {
      _showInvalidDayAlert(context, userSex);
      return;
    }

    final newExit = {
      'FechaSolicitada': DateTime.now().toIso8601String(),
      'StatusPermission': 'Pendiente',
      'FechaSalida': _selectedStartDate.toIso8601String(),
      'FechaRegreso': _selectedEndDate.toIso8601String(),
      'Motivo': _selectedReason,
      'Tipo': _selectedType,
      'IdUser': userId,
      'IdTipoSalida': typeMap[_selectedType],
    };

    try {
      final result = await _permissionService.createPermission(newExit);

      // Crear instancia de Permission
      Permission newPermission = Permission(
        id: result['IdPermission'] as int? ?? 0,
        fechasolicitud: DateTime.parse(newExit['FechaSolicitada'] as String),
        statusPermission: result['StatusPermission'] as String? ?? 'Pendiente',
        fechasalida: DateTime.parse(newExit['FechaSalida'] as String),
        fecharegreso: DateTime.parse(newExit['FechaRegreso'] as String),
        motivo: newExit['Motivo'] as String? ?? '',
        idlogin: newExit['IdUser'] as int? ?? 0,
        idsalida: newExit['IdTipoSalida'] as int? ?? 0,
        observaciones: '', // Agrega cualquier campo adicional requerido
        descripcion: newExit['Tipo'] as String? ?? '',
        nombre: userInfo['Nombre'] as String? ?? '',
        apellidos: userInfo['Apellidos'] as String? ?? '',
        contacto: userInfo['Celular'] as String? ?? '',
        trabajo: userInfo['DEPARTAMENTO'] as String? ??
            '', // Agrega cualquier campo adicional requerido
        jefetrabajo: '', // Agrega cualquier campo adicional requerido
        nombretutor: '', // Agrega cualquier campo adicional requerido
        apellidotutor: '', // Agrega cualquier campo adicional requerido
        moviltutor: '', // Agrega cualquier campo adicional requerido
        matricula: userInfo['MATRICULA'] as String? ?? '',
        correo: userInfo['Correo'] as String? ?? '',
        tipoUser: userInfo['TipoUser'] as String? ?? '',
        sexo: userInfo['Sexo'] as String? ?? '',
        fechaNacimiento: DateTime.parse(
            userInfo['FechaNacimiento'] as String? ?? '1900-01-01'),
        celular: userInfo['Celular'] as String? ?? '',
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context, newPermission);
    } catch (e) {
      // ignore: avoid_print
      print('Failed to create exit: $e');
    }
  }

  bool _isValidDayForSex(String sex, DateTime date) {
    final int dayOfWeek =
        date.weekday; // 1 = Lunes, 2 = Martes, ..., 7 = Domingo
    if (sex == 'F' && (dayOfWeek == 1 || dayOfWeek == 3)) {
      return true;
    } else if (sex == 'M' && (dayOfWeek == 2 || dayOfWeek == 4)) {
      return true;
    }
    return false;
  }

  void _showInvalidDayAlert(BuildContext context, String sex) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Día no permitido'),
          content: Text(sex == 'F'
              ? 'Las mujeres solo pueden crear salidas los lunes y miércoles.'
              : 'Los hombres solo pueden crear salidas los martes y jueves.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear salida',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6D55F4),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tipo de salida',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildChoiceChip('Pueblo'),
                _buildChoiceChip('Especial'),
                _buildChoiceChip('A casa'),
              ],
            ),
            const SizedBox(height: 20),
            _buildDateTimePicker('Fecha y hora de salida', _selectedStartDate,
                _selectedStartTime, true),
            const SizedBox(height: 20),
            _buildDateTimePicker('Fecha y hora de retorno', _selectedEndDate,
                _selectedEndTime, false,
                enabled: _selectedType != 'Pueblo'),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA726),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                _createExit(context);
              },
              child: const Text(
                'Crear salida',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
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
      selectedColor: const Color.fromRGBO(182, 217, 59, 1),
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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: enabled ? () => _selectDateTime(context, isStart) : null,
          child: InputDecorator(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.all(10),
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
