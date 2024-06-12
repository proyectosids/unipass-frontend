import 'package:flutter_application_unipass/utils/imports.dart';

class SupportUserScreen extends StatefulWidget {
  static const routeName = '/supportUser';
  const SupportUserScreen({super.key});

  @override
  State<SupportUserScreen> createState() => _SupportUserScreenState();
}

class _SupportUserScreenState extends State<SupportUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Seccion de soporte'),
      ),
    );
  }
}
