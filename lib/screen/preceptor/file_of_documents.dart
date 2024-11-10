import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/shared_preferences/user_preferences.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:flutter_application_unipass/services/document_service.dart';
import 'package:flutter_application_unipass/config/config_url.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart'; // Importar flutter_cached_pdfview

class FileOfDocuments extends StatefulWidget {
  const FileOfDocuments({super.key});
  static const routeName = '/fileDocuments';

  @override
  State<FileOfDocuments> createState() => _FileOfDocumentsState();
}

class _FileOfDocumentsState extends State<FileOfDocuments> {
  List<Map<String, dynamic>> expedientes = [];
  List<Map<String, dynamic>> filteredExpedientes = [];
  bool isLoading = true;
  int? idDormi;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDormitorioAndExpedientes();
  }

  Future<void> _loadDormitorioAndExpedientes() async {
    try {
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
        filteredExpedientes = result;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar expedientes: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToDocumentListScreen(
      int dormitorio, String nombre, String apellidos) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DocumentListScreen(
        dormitorio: dormitorio,
        nombre: nombre,
        apellidos: apellidos,
      ),
    ));
  }

  void _filterExpedientes(String query) {
    List<Map<String, dynamic>> results = [];
    if (query.isEmpty) {
      results = expedientes;
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
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (query) {
                      _filterExpedientes(query);
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredExpedientes.length,
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
                            _navigateToDocumentListScreen(idDormi!,
                                expediente['Nombre'], expediente['Apellidos']);
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

class DocumentListScreen extends StatelessWidget {
  final int dormitorio;
  final String nombre;
  final String apellidos;

  const DocumentListScreen({
    Key? key,
    required this.dormitorio,
    required this.nombre,
    required this.apellidos,
  }) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse('$baseUrl$url');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _getDocumentos() async {
    try {
      return await DocumentService()
          .getArchivosAlumno(dormitorio, nombre, apellidos);
    } catch (e) {
      print('Error al obtener archivos: $e');
      return [];
    }
  }

  void _openDocument(BuildContext context, String archivo) {
    if (archivo.endsWith('.pdf')) {
      // Si el archivo es un PDF, navegar a la pantalla de visualización de PDF
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PdfViewerScreen(url: archivo),
        ),
      );
    } else {
      // Si no es PDF, usar el método _launchURL
      _launchURL(archivo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Documentos de $nombre',
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getDocumentos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los documentos'));
          }

          final documentos = snapshot.data ?? [];

          if (documentos.isEmpty) {
            return const Center(child: Text('No se encontraron documentos.'));
          }

          return ListView.builder(
            itemCount: documentos.length,
            itemBuilder: (context, index) {
              final documento = documentos[index];
              final tipoDocumento = documento['TipoDocumento'];
              final archivo = documento['Archivo'];

              return ListTile(
                title: Text(tipoDocumento),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _openDocument(
                      context, archivo); // Abrir el documento al hacer clic
                },
              );
            },
          );
        },
      ),
    );
  }
}

class PdfViewerScreen extends StatelessWidget {
  final String url;

  const PdfViewerScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Construye la URL completa usando $baseUrl
    final String fullUrl = '$baseUrl$url';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Visualizar PDF',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
      body: const PDF().cachedFromUrl(
        fullUrl, // Usamos la URL completa con baseUrl
        placeholder: (progress) => Center(child: Text('$progress %')),
        errorWidget: (error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
