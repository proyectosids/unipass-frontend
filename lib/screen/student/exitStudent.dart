import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Exitstudent extends StatelessWidget {
  static const routeName = '/ExitStudent';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserTripsScreen(),
    );
  }
}

class UserTripsScreen extends StatefulWidget {
  @override
  _UserTripsScreenState createState() => _UserTripsScreenState();
}

class _UserTripsScreenState extends State<UserTripsScreen> {
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  List<Map<String, String>> _trips = [
    {
      'title': 'Salida al pueblo',
      'time': 'hace 12 horas',
      'status': 'Pendiente',
    },
    {
      'title': 'Salida al pueblo',
      'time': 'hace 2 días',
      'status': 'Finalizado',
    },
    {
      'title': 'Salida especial',
      'time': 'hace 8 días',
      'status': 'Finalizado',
    },
    {
      'title': 'Salida a casa',
      'time': 'hace 23 días',
      'status': 'Finalizado',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.purple),
          onPressed: () {
            // Acción al presionar el ícono de retroceso
          },
        ),
        title: Text('Salidas'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _calendarFormat = CalendarFormat.week;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _selectedDay = focusedDay;
            },
          ),
          SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón "Nueva Salida"
              },
              child: Text('Nueva Salida'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView.builder(
                itemCount: _trips.length,
                itemBuilder: (context, index) {
                  final trip = _trips[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading:
                          Icon(Icons.directions_walk, color: Colors.purple),
                      title: Text(trip['title']!),
                      subtitle: Text(trip['time']!),
                      trailing: Text(
                        trip['status']!,
                        style: TextStyle(
                          color: trip['status'] == 'Pendiente'
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
            tooltip: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '',
            tooltip: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
            tooltip: 'Profile',
          ),
        ],
        onTap: (index) {
          // Acción al cambiar de pestaña en la barra de navegación inferior
        },
      ),
    );
  }
}
