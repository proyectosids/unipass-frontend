import 'package:flutter_application_unipass/utils/imports.dart';

class PrivacyuserScreen extends StatefulWidget {
  static const routeName = '/privacyUser';
  const PrivacyuserScreen({super.key});

  @override
  State<PrivacyuserScreen> createState() => _PrivacyuserScreenState();
}

class _PrivacyuserScreenState extends State<PrivacyuserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Politicas de privacidad'),
      ),
    );
  }
}
