import 'package:flutter_application_unipass/utils/imports.dart';

class NotificationsScreen extends StatelessWidget {
  static const routeName = '/notificationsStudent';

  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.purple),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildNotificationItem(
                'Salida al pueblo aprobada', 'El preceptor aprobó tu salida'),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: const Icon(Icons.notifications, color: Colors.purple),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
