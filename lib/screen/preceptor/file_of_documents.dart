import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Documentos",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
