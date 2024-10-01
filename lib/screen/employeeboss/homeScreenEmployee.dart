import 'package:flutter_application_unipass/screen/employeeboss/index/home_employee.dart';
import 'package:flutter_application_unipass/utils/imports.dart';

class HomeScreenEmployee extends StatefulWidget {
  static const routeName = '/homeEmployeeMenu';

  const HomeScreenEmployee({Key? key}) : super(key: key);

  @override
  _HomeScreenEmployeeState createState() => _HomeScreenEmployeeState();
}

class _HomeScreenEmployeeState extends State<HomeScreenEmployee> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const HomeEmployeeScreen(),
    const MenuEmployeeScreen(),
    const ProfileScreen(
        userType: 'jefe de departamento'), // Pasa el tipo de usuario
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromRGBO(6, 66, 106, 1),
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home_filled),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            activeIcon: Icon(Icons.menu_book),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.person_pin),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
