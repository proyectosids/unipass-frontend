import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/screen/NewAccount/newaccount1.dart';
import 'package:flutter_application_unipass/screen/NewAccount/newaccount2.dart';
import 'package:flutter_application_unipass/screen/login/login.dart';
import 'package:flutter_application_unipass/screen/Preview/preview1.dart';
import 'package:flutter_application_unipass/screen/Preview/preview2.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniPass ULV',
      initialRoute: '/', //Iniciamos la ruta
      routes: {
        //Asignamos las rutas que vayamos a ocupara
        '/': (context) => const Preview1(),
        '/next': (context) => const Preview2(),
        '/login': (context) => const LoginApp(),
        '/NewAccount1': (context) => const NewAccount1(),
        '/NewAccount2': (context) => const NewAccount2(),
      },
    );
  }
}
