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
    const ProfileScreen(userType: 'PRECEPTOR'), // Pasa el tipo de usuario
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final int? indexArg = ModalRoute.of(context)?.settings.arguments as int?;
    if (indexArg != null && indexArg >= 0 && indexArg < screens.length) {
      setState(() {
        selectedIndex = indexArg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
      ),
    );
  }
}
