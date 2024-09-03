import 'package:flutter_application_unipass/utils/imports.dart';

class HomeScreenDepartament extends StatefulWidget {
  static const routeName = '/homeDepartamentMenu';

  const HomeScreenDepartament({Key? key}) : super(key: key);

  @override
  _HomeScreenDepartamentState createState() => _HomeScreenDepartamentState();
}

class _HomeScreenDepartamentState extends State<HomeScreenDepartament> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const HomeDepartament(),
    const HelpFAQUser(),
    const ProfileScreen(userType: 'departamento'), // Pasa el tipo de usuario
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
            icon: Icon(Icons.help),
            activeIcon: Icon(Icons.help),
            label: 'Ayuda',
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
