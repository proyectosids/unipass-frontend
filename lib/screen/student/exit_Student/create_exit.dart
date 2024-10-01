import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_unipass/services/authorize_service.dart';
import 'package:flutter_application_unipass/services/permission_service.dart';
import 'package:flutter_application_unipass/services/auth_service.dart';
import 'package:flutter_application_unipass/models/permission.dart';
import 'package:flutter_application_unipass/services/register_service.dart';
import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';

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
  String _selectedType = '';
  final PermissionService _permissionService =
      PermissionService(RegisterService(), AuthorizeService());
  final AuthServices _authService = AuthServices();
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
    if (isStart) {
      // Para el campo de salida, solo permitir la selección de la hora
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: isStart ? _selectedStartTime : _selectedEndTime,
      );

      if (pickedTime != null) {
        setState(() {
          _selectedStartTime = pickedTime;
          _selectedEndTime = TimeOfDay(
            hour: (pickedTime.hour + 4) % 24,
            minute: pickedTime.minute,
          );
        });
      }
    } else {
      // Para el campo de retorno, permitir selección de fecha y hora
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
            _selectedEndDate = pickedDate;
            _selectedEndTime = pickedTime;
          });
        }
      }
    }
  }

  // No convertimos la hora, solo tomamos la hora local del dispositivo
  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  String _formatDateTime(DateTime date, TimeOfDay time) {
    final DateTime dateTime = _combineDateAndTime(date, time);
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

    Map<String, dynamic>? userInfo = await _authService.getUserInfo(userId);
    if (userInfo == null) {
      print('User info not found');
      return;
    }

    String userSex = userInfo['Sexo'] ?? '';
    if (_selectedType == 'Pueblo' &&
        !_isValidDayForSex(userSex, _selectedStartDate)) {
      _showInvalidDayAlert(context, userSex);
      return;
    }

    // Registrar la fecha y hora seleccionada del dispositivo
    final DateTime fechaSalida =
        _combineDateAndTime(_selectedStartDate, _selectedStartTime);
    final DateTime fechaRegreso =
        _combineDateAndTime(_selectedEndDate, _selectedEndTime);

    final newExit = {
      'FechaSolicitada': DateTime.now().toIso8601String(),
      'StatusPermission': 'Pendiente',
      'FechaSalida': fechaSalida.toIso8601String(),
      'FechaRegreso': fechaRegreso.toIso8601String(),
      'Motivo': _selectedReason,
      'Tipo': _selectedType,
      'IdUser': userId,
      'IdTipoSalida': typeMap[_selectedType],
    };

    try {
      final result = await _permissionService.createPermission(newExit);

      Permission newPermission = Permission(
        id: result['IdPermission'] as int? ?? 0,
        fechasolicitud: DateTime.parse(newExit['FechaSolicitada'] as String),
        statusPermission: result['StatusPermission'] as String? ?? 'Pendiente',
        fechasalida: DateTime.parse(newExit['FechaSalida'] as String),
        fecharegreso: DateTime.parse(newExit['FechaRegreso'] as String),
        motivo: newExit['Motivo'] as String? ?? '',
        idlogin: newExit['IdUser'] as int? ?? 0,
        idsalida: newExit['IdTipoSalida'] as int? ?? 0,
        observaciones: '',
        descripcion: newExit['Tipo'] as String? ?? '',
        nombre: userInfo['Nombre'] as String? ?? '',
        apellidos: userInfo['Apellidos'] as String? ?? '',
        contacto: userInfo['Celular'] as String? ?? '',
        idTrabajo: userInfo['ID DEPTO'] as int? ?? 0,
        trabajo: userInfo['DEPARTAMENTO'] as String? ?? '',
        idJefeTrabajo: userInfo['ID JEFE'] as int? ?? 0,
        jefetrabajo: '',
        nombretutor: '',
        apellidotutor: '',
        moviltutor: '',
        matricula: userInfo['MATRICULA'] as String? ?? '',
        correo: userInfo['Correo'] as String? ?? '',
        tipoUser: userInfo['TipoUser'] as String? ?? '',
        sexo: userInfo['Sexo'] as String? ?? '',
        fechaNacimiento: DateTime.parse(
            userInfo['FechaNacimiento'] as String? ?? '1900-01-01'),
        celular: userInfo['Celular'] as String? ?? '',
      );

      Navigator.pop(context, newPermission);
    } catch (e) {
      print('Failed to create exit: $e');
    }
  }

  bool _isValidDayForSex(String sex, DateTime date) {
    final int dayOfWeek = date.weekday;
    if (sex == 'F' && (dayOfWeek == 1 || dayOfWeek == 3)) {
      return true;
    } else if (sex == 'M' && (dayOfWeek == 2 || dayOfWeek == 4)) {
      return true;
    }
    return false;
  }

  void _showInvalidDayAlert(BuildContext context, String sex) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(5);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive.wp(10)),
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Día no permitido',
                  style: TextStyle(
                    fontSize: responsive.dp(2.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: responsive.hp(4)),
                Text(
                  sex == 'F'
                      ? 'Las salidas para señoritas estarán disponibles únicamente los días lunes y miércoles.'
                      : 'Las salidas para varones estarán disponibles únicamente los días martes y jueves.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: responsive.dp(1.8),
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: responsive.hp(4)),
                SizedBox(
                  width: responsive.wp(50),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(responsive.wp(30)),
                      ),
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: responsive.dp(2),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(5);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(6, 66, 106, 1),
        centerTitle: true,
        title: Text(
          'Crear salida',
          style: TextStyle(
              color: Colors.white,
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
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tipo de salida',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: responsive.dp(1.9)),
              ),
              SizedBox(height: responsive.hp(1.5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildChoiceChip('Pueblo'),
                  _buildChoiceChip('Especial'),
                  _buildChoiceChip('A casa'),
                ],
              ),
              const SizedBox(height: 20),
              _buildDateTimePickerSalida('Fecha y hora de salida',
                  _selectedStartDate, _selectedStartTime, true),
              const SizedBox(height: 20),
              _buildDateTimePickerRetorno('Fecha y hora de retorno',
                  _selectedEndDate, _selectedEndTime, false,
                  enabled: _selectedType != 'Pueblo'),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedReason,
                decoration: const InputDecoration(labelText: 'Motivo'),
                items: <String>['Compras', 'Trabajo', 'Salud', 'Otros']
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
      selectedColor: const Color.fromRGBO(182, 220, 225, 1),
    );
  }

  Widget _buildDateTimePickerSalida(
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
                  time.format(context),
                  style: TextStyle(color: enabled ? Colors.black : Colors.grey),
                ),
                Icon(Icons.access_time,
                    color: enabled ? Colors.black : Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimePickerRetorno(
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
