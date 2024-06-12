import 'package:flutter_application_unipass/utils/imports.dart';
import 'package:intl/intl.dart';

class ExitStudent extends StatefulWidget {
  static const routeName = '/ExitStudent';

  const ExitStudent({Key? key}) : super(key: key);

  @override
  _ExitStudentState createState() => _ExitStudentState();
}

class _ExitStudentState extends State<ExitStudent> {
  DateTime _selectedDate = DateTime.now();
  List<Map<String, String>> _exits = [
    {
      'title': 'Salida Pueblo',
      'date': 'el 2024-06-05 01:00 PM',
      'status': 'Pendiente',
      'detail': 'Detalles de la salida al pueblo'
    },
    {
      'title': 'Salida Pueblo',
      'date': 'el 2024-05-26 10:00 AM',
      'status': 'Finalizado',
      'detail': 'Detalles de la salida al pueblo (finalizada)'
    },
    {
      'title': 'Salida Especial',
      'date': 'el 2024-05-15 11:00 AM',
      'status': 'Finalizado',
      'detail': 'Detalles de la salida especial'
    },
    {
      'title': 'Salida A casa',
      'date': 'el 2024-04-09 09:00 AM',
      'status': 'Finalizado',
      'detail': 'Detalles de la salida a casa'
    },
  ];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting(
        'es_ES', null); // Inicializa la localización en español
  }

  void _addNewExit(Map<String, String> newExit) {
    setState(() {
      _exits.insert(0, newExit); // Insertar al inicio de la lista
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salidas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildDatePicker(),
            const SizedBox(height: 16),
            const Text(
              'Salidas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _exits.length,
                itemBuilder: (context, index) {
                  final exit = _exits[index];
                  return exit['status'] == 'Pendiente'
                      ? Dismissible(
                          key: Key(exit['title']!),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await _showConfirmationDialog(context);
                          },
                          onDismissed: (direction) {
                            setState(() {
                              _exits.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('${exit['title']} eliminado')),
                            );
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          child: _buildExitItem(
                            context,
                            exit['title']!,
                            exit['date']!,
                            exit['status']!,
                            exit,
                          ),
                        )
                      : _buildExitItem(
                          context,
                          exit['title']!,
                          exit['date']!,
                          exit['status']!,
                          exit,
                        );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Salidas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    String formattedDate = DateFormat.yMMMM('es_ES').format(_selectedDate);
    String capitalizedDate = capitalizeFirstLetter(formattedDate);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          capitalizedDate,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateExitScreen(
                  initialDate: _selectedDate,
                ),
              ),
            );
            if (result != null) {
              _addNewExit(result);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            'Nueva Salida',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        locale: 'es',
        initialSelectedDate: _selectedDate,
        selectionColor: Colors.purple,
        selectedTextColor: Colors.white,
        dayTextStyle: TextStyle(color: Colors.black),
        dateTextStyle:
            TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        monthTextStyle: TextStyle(color: Colors.black),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar esta salida?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExitItem(BuildContext context, String title, String date,
      String status, Map<String, String> exit) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/exitDetail', arguments: exit);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          leading: SizedBox(
            width: 40,
            height: 40,
            child: Icon(Icons.event),
          ),
          title: Text(title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date),
              const SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(
                  color: status == 'Pendiente' ? Colors.orange : Colors.green,
                ),
              ),
            ],
          ),
          trailing: Icon(Icons.more_vert),
        ),
      ),
    );
  }
}
