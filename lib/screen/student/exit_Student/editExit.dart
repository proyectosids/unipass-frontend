import 'package:flutter/material.dart';

class EditExitScreen extends StatelessWidget {
  static const routeName = '/editExit';

  const EditExitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String exitTitle =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar $exitTitle'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: exitTitle,
              decoration: const InputDecoration(labelText: 'Tipo de salida'),
            ),
            TextFormField(
              initialValue: '20 May, 2024, 11:30 AM',
              decoration:
                  const InputDecoration(labelText: 'Fecha y hora de salida'),
            ),
            TextFormField(
              initialValue: '20 May, 2024, 3:30 PM',
              decoration:
                  const InputDecoration(labelText: 'Fecha y hora de retorno'),
            ),
            TextFormField(
              initialValue: 'Compras',
              decoration: const InputDecoration(labelText: 'Motivo'),
            ),
            ElevatedButton(
              onPressed: () {
                // Aquí agregas la lógica para actualizar la salida
                Navigator.pop(context);
              },
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
