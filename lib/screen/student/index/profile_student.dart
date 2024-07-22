import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/services/document_service.dart';
import 'package:flutter_application_unipass/utils/auth_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_unipass/config/config_url.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profileStudent';
  final String userType; // Añade este campo

  const ProfileScreen({Key? key, required this.userType}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  String? profileImageUrl;
  bool _notificationsEnabled =
      false; // Estado para el interruptor de notificaciones
  final DocumentService _documentService = DocumentService();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    int? idDocumento = 8;
    int? id = await AuthUtils.getUserId();
    if (id == null) {
      print('User ID not found');
      return;
    }
    String? imageUrl = await _documentService.getProfile(id, idDocumento);
    setState(() {
      profileImageUrl = imageUrl != null ? '$baseUrl$imageUrl' : null;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    int? idDocumento = 8;
    int? id = await AuthUtils.getUserId();
    if (id == null) {
      print('User ID not found');
      return;
    }

    setState(() {
      imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });

    if (imageFile != null) {
      await _documentService.uploadDocument(imageFile!, idDocumento, id);
      _loadProfileImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    String profileText = widget.userType == 'student'
        ? 'Alumno'
        : 'Empleado'; // Cambia según el tipo de usuario

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notificationsStudent');
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: imageFile != null
                    ? FileImage(imageFile!)
                    : (profileImageUrl != null
                        ? NetworkImage(profileImageUrl!)
                        : null) as ImageProvider<Object>?,
                child: imageFile == null && profileImageUrl == null
                    ? const Icon(
                        Icons.add_a_photo,
                        size: 50,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(profileText,
                style: const TextStyle(fontSize: 24)), // Usa el texto dinámico
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Activar notificaciones',
                    style: TextStyle(fontSize: 16)),
                Switch(
                  value: _notificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  _buildProfileItem(
                    context,
                    'Cambiar contraseña',
                    'assets/image/cambiar_contra.svg',
                    '/changeStudent',
                    const Color.fromARGB(255, 107, 128, 246),
                  ),
                  _buildProfileItem(context, 'Soporte',
                      'assets/image/soporte.svg', '/supportUser', Colors.green),
                  _buildProfileItem(
                      context,
                      'Políticas de Privacidad',
                      'assets/image/politicas.svg',
                      '/privacyUser',
                      const Color.fromARGB(255, 159, 60, 176)),
                  _buildProfileItem(context, 'Cerrar sesión',
                      'assets/image/cerrar_sesion.svg', '/login', Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, String title, String assetPath,
      String routeName, Color color) {
    return GestureDetector(
      onTap: () {
        if (routeName == '/login') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            routeName,
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.pushNamed(context, routeName);
        }
      },
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(assetPath, width: 80, height: 80),
            const SizedBox(height: 8),
            Text(title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }
}
