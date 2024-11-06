import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/services/document_service.dart';
import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_unipass/config/config_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    int? idDocumento =
        8; // Asegúrate de que este ID es correcto para tu caso de uso
    int? id = await AuthUtils.getUserId();

    if (id == null) {
      print('User ID not found');
      return;
    }

    setState(() {
      imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });

    if (imageFile != null) {
      // Determinar si cargar una nueva imagen o actualizar una existente
      if (profileImageUrl == null) {
        // Si no hay imagen de perfil, cargar una nueva
        await _documentService.uploadDocument(imageFile!, idDocumento, id);
      } else {
        // Si ya existe una imagen de perfil, actualizarla
        await _documentService.uploadProfile(imageFile!, idDocumento, id);
      }
      _loadProfileImage();
    }
  }

  Future<void> _clearUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpia todas las preferencias
  }

  @override
  Widget build(BuildContext context) {
    String profileText = widget.userType == 'student'
        ? 'Alumno'
        : 'Empleado'; // Cambia según el tipo de usuario

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
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
                    Colors.white,
                  ),
                  _buildProfileItem(
                    context,
                    'Soporte',
                    'assets/image/soporte.svg',
                    '/supportUser',
                    Colors.white,
                  ),
                  _buildProfileItem(
                    context,
                    'Políticas de Privacidad',
                    'assets/image/politicas.svg',
                    '/privacyUser',
                    Colors.white,
                  ),
                  _buildProfileItem(
                    context,
                    'Cerrar sesión',
                    'assets/image/cerrar_sesion.svg',
                    '/login',
                    Colors.white,
                  ),
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
    final Responsive responsive = Responsive.of(context);
    return GestureDetector(
      onTap: () async {
        if (routeName == '/login') {
          await _clearUserPreferences(); // Limpia SharedPreferences antes de cerrar sesión
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
        elevation: 20, // Aquí añades la elevación
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(assetPath,
                width: responsive.wp(12), height: responsive.hp(12)),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: responsive.dp(1.6),
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
