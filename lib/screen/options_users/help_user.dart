import 'package:flutter/material.dart';

class HelpFAQUser extends StatefulWidget {
  static const routeName = '/helpUser';
  const HelpFAQUser({super.key});

  @override
  State<HelpFAQUser> createState() => _HelpFAQUserState();
}

class _HelpFAQUserState extends State<HelpFAQUser> {
  List<Item> _faqItems = [
    Item(
      headerValue: '¿Porqué no puedo solicitar una salida?',
      expandedValue:
          'Lo más frecuente es que no tengas tus documentos completos en la sección de “Documentos” o hayas excedido tu límite de salidas permitidas.',
    ),
    Item(
      headerValue:
          '¿Qué hago si mi jefe de área no me ha autorizado mi salida?',
      expandedValue:
          'Debes contactar a tu jefe directamente para resolver el problema.',
    ),
    Item(
      headerValue: '¿Dónde puedo cambiar mi área de trabajo?',
      expandedValue:
          'Puedes cambiar tu área de trabajo en la sección de “Perfil” en la app.',
    ),
    Item(
      headerValue: '¿Porqué un jefe puede rechazar la solicitud?',
      expandedValue:
          'Tu jefe puede rechazar la solicitud por varias razones, incluyendo necesidades operativas o falta de documentos.',
    ),
    Item(
      headerValue: '¿Cómo sé que un alumno llegó tarde?',
      expandedValue:
          'Puedes revisar el historial de asistencia en la sección de “Reportes” en la app.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('FAQ'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Cómo podemos ayudarte?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              children: [
                _buildSectionButton(
                  context,
                  icon: Icons.notifications,
                  label: 'Notificaciones',
                  color: Colors.lightBlue[100]!,
                ),
                _buildSectionButton(
                  context,
                  icon: Icons.directions_walk,
                  label: 'Las salidas',
                  color: Colors.green[100]!,
                ),
                _buildSectionButton(
                  context,
                  icon: Icons.assignment,
                  label: 'Autorizaciones',
                  color: Colors.red[100]!,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Preguntas más frecuentes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Lógica para navegar a otra sección de "Ver todo"
                  },
                  child: const Text('Ver todo'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildExpansionTileList(),
          ],
        ),
      ),
      //bottomNavigationBar: BottomNavigationBar(
      //  items: const <BottomNavigationBarItem>[
      //    BottomNavigationBarItem(
      //      icon: Icon(Icons.home),
      //      label: 'Inicio',
      //    ),
      //    BottomNavigationBarItem(
      //      icon: Icon(Icons.list),
      //      label: 'Salidas',
      //    ),
      //    BottomNavigationBarItem(
      //      icon: Icon(Icons.person),
      //      label: 'Perfil',
      //    ),
      //  ],
      //),
    );
  }

  Widget _buildSectionButton(BuildContext context,
      {required IconData icon, required String label, required Color color}) {
    return GestureDetector(
      onTap: () {
        // Lógica para navegar a otra sección
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTileList() {
    return Column(
      children: _faqItems.map<Widget>((Item item) {
        return ExpansionTile(
          title: Text(
            item.headerValue,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: [
            ListTile(
              title: Text(item.expandedValue),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class Item {
  Item({
    required this.headerValue,
    required this.expandedValue,
    this.isExpanded = false,
  });

  String headerValue;
  String expandedValue;
  bool isExpanded;
}
