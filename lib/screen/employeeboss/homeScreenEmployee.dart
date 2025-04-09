import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_unipass/config/config_url.dart';
import 'package:flutter_application_unipass/utils/imports.dart';

class HomeScreenEmployee extends StatefulWidget {
  static const routeName = '/homeEmployeeMenu';

  const HomeScreenEmployee({Key? key}) : super(key: key);

  @override
  _HomeScreenEmployeeState createState() => _HomeScreenEmployeeState();
}

class _HomeScreenEmployeeState extends State<HomeScreenEmployee>
    with WidgetsBindingObserver {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const HomeEmployeeScreen(),
    const MenuEmployeeScreen(),
    const ProfileScreen(userType: 'JEFE DE AREA'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      bool isValid = await _checkToken();
      if (!isValid && mounted) {
        await AuthUtils.clearSessionToken();
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      }
    }
  }

  Future<bool> _checkToken() async {
    final token = await AuthUtils.getSessionToken();
    if (token == null) return false;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/verifyToken'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

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
