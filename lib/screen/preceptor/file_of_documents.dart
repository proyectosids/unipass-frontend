import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';

class FileOfDocuments extends StatefulWidget {
  const FileOfDocuments({super.key});
  static const routeName = '/fileDocuments';

  @override
  State<FileOfDocuments> createState() => _FileOfDocumentsState();
}

class _FileOfDocumentsState extends State<FileOfDocuments> {
  final List<String> alumnos = [
    "Carlos Méndez",
    "Juan Pérez",
    "Juan Pablo García",
    "José Luis Gutiérrez",
    "Alejandro Vargas",
    "Miguel Ángel Sánchez",
    "David Fernández",
    "Daniel Jiménez",
    "Luis Alberto Gómez",
    "Francisco Martínez",
    "Rafael Díaz",
    "Eduardo Ramírez",
    "Andrés Morales",
    "Fernando Herrera",
    "Javier Ríos",
    "Julio César López",
    "Marcos Delgado",
    "Mario Ortega"
  ];

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(3);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Documentos",
          style: TextStyle(
              color: Color.fromRGBO(250, 198, 0, 1),
              fontSize: responsive.dp(2.2)),
        ),
        backgroundColor: const Color.fromRGBO(6, 66, 106, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(250, 198, 0, 1),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(padding),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: alumnos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {
                      // Acción al presionar el botón
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        alumnos[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
