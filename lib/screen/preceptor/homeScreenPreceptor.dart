import 'package:flutter_application_unipass/screen/preceptor/index/menu_preceptor.dart';
import 'package:flutter_application_unipass/utils/imports.dart';

class HomeScreenPreceptor extends StatefulWidget {
  static const routeName = '/homePreceptorMenu';

  const HomeScreenPreceptor({Key? key}) : super(key: key);

  @override
  _HomeScreenPreceptorState createState() => _HomeScreenPreceptorState();
}

class _HomeScreenPreceptorState extends State<HomeScreenPreceptor> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const HomePreceptorScreen(),
    const MenuPreceptorScreen(),
    ProfileScreen(userType: 'preceptor'), // Pasa el tipo de usuario
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
