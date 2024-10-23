import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:flutter_application_unipass/services/document_service.dart'; // Importa el servicio

class FileOfDocuments extends StatefulWidget {
  const FileOfDocuments({super.key});
  static const routeName = '/fileDocuments';

  @override
  State<FileOfDocuments> createState() => _FileOfDocumentsState();
}

class _FileOfDocumentsState extends State<FileOfDocuments> {
  List<Map<String, dynamic>> expedientes = [];
  List<Map<String, dynamic>> filteredExpedientes = []; // Lista filtrada
  bool isLoading = true;
  int? idDormi;
  TextEditingController searchController =
      TextEditingController(); // Controlador del buscador

  @override
  void initState() {
    super.initState();
    _loadDormitorioAndExpedientes();
  }

  Future<void> _loadDormitorioAndExpedientes() async {
    try {
      // Obtén el IdDormitorio de SharedPreferences
      int? dormitorioId = await AuthUtils.getIdDormitorio();

      if (dormitorioId != null) {
        setState(() {
          idDormi = dormitorioId;
        });
        await _loadExpedientes();
      } else {
        print("IdDormitorio no encontrado en SharedPreferences");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error al obtener IdDormitorio: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadExpedientes() async {
    if (idDormi == null) return;

    try {
      final List<Map<String, dynamic>> result =
          await DocumentService().getExpedientesPorDormitorio(idDormi!);
      setState(() {
        expedientes = result;
        filteredExpedientes =
            result; // Inicialmente la lista filtrada es igual a la lista completa
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar expedientes: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterExpedientes(String query) {
    List<Map<String, dynamic>> results = [];
    if (query.isEmpty) {
      results =
          expedientes; // Si la búsqueda está vacía, mostrar todos los expedientes
    } else {
      results = expedientes.where((expediente) {
        final nombreCompleto =
            '${expediente['Nombre']} ${expediente['Apellidos']}';
        return nombreCompleto.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    setState(() {
      filteredExpedientes = results;
    });
  }

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
              color: Colors.white,
              fontSize: responsive.dp(2.2),
              fontWeight: FontWeight.w600),
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
      backgroundColor: const Color.fromRGBO(189, 188, 188, 1),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Buscar',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      filled: true, // Activa el color de fondo
                      fillColor: Colors.white, // Color de fondo blanco
                    ),
                    onChanged: (query) {
                      _filterExpedientes(
                          query); // Filtrar expedientes a medida que se escribe
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        filteredExpedientes.length, // Mostrar la lista filtrada
                    itemBuilder: (context, index) {
                      final expediente = filteredExpedientes[index];
                      final nombreCompleto =
                          '${expediente['Nombre']} ${expediente['Apellidos']}';
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
                            print('Expediente seleccionado: $nombreCompleto');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              nombreCompleto,
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
