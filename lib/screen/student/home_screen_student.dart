import 'package:flutter_application_unipass/utils/imports.dart';

class HomeScreenStudent extends StatefulWidget {
  static const routeName = '/homeStudentMenu';

  const HomeScreenStudent({Key? key}) : super(key: key);

  @override
  _HomeScreenStudentState createState() => _HomeScreenStudentState();
}

class _HomeScreenStudentState extends State<HomeScreenStudent> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const HomeStudentScreen(),
    const MenuScreen(),
    const ProfileScreen(userType: 'student'), // Pasa el tipo de usuario
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
