import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/screen/NewAccount/mailAuthentication.dart';
import 'package:flutter_application_unipass/screen/NewAccount/verificacionAccount.dart';
import 'package:flutter_application_unipass/screen/NewAccount/accountCredentials.dart';
import 'package:flutter_application_unipass/screen/login/login.dart';
import 'package:flutter_application_unipass/screen/Preview/preview1.dart';
import 'package:flutter_application_unipass/screen/Preview/preview2.dart';
import 'package:flutter_application_unipass/screen/recoverpassword/maillAuthentication.dart';
import 'package:flutter_application_unipass/screen/recoverpassword/verificationPassword.dart';
import 'package:flutter_application_unipass/screen/recoverpassword/newPassword.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniPass ULV',
      initialRoute: Preview1.routeName, //Iniciamos la ruta
      routes: {
        Preview1.routeName: (context) => const Preview1(),
        Preview2.routeName: (context) => const Preview2(),
        LoginApp.routeName: (context) => const LoginApp(),
        NewAccountAuthentication.routeName: (context) =>
            const NewAccountAuthentication(),
        VerificationNewAccount.routeName: (context) =>
            const VerificationNewAccount(),
        NewAccountCredentials.routeName: (context) =>
            const NewAccountCredentials(),
        AuthenticationPassword.routeName: (context) =>
            const AuthenticationPassword(),
        VerificationPassword.routeName: (context) =>
            const VerificationPassword(),
        CreateNewPassword.routeName: (context) => const CreateNewPassword(),
      },
    );
  }
}
