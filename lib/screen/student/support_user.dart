import 'package:flutter_application_unipass/utils/imports.dart';

class SupportUserScreen extends StatefulWidget {
  static const routeName = '/supportUser';
  const SupportUserScreen({super.key});

  @override
  State<SupportUserScreen> createState() => _SupportUserScreenState();
}

class _SupportUserScreenState extends State<SupportUserScreen> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(5); // 5% del ancho de la pantalla

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(6, 66, 106, 1),
        centerTitle: true,
        title: Text(
          'Soporte',
          style: TextStyle(
              color: const Color.fromRGBO(250, 198, 0, 1),
              fontSize: responsive.dp(2.2)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromRGBO(250, 198, 0, 1)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: responsive.hp(2)),
                  Text(
                    '¿Hay algo que podamos hacer para mejorar tu experiencia?',
                    style: TextStyle(
                      fontSize: responsive.dp(2.2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: responsive.hp(2)),
                  Text(
                    'Bienvenido al soporte de nuestra aplicación de control de salidas y entradas. Aquí encontrarás nuestros contactos de ayuda para interpretar reportes y resolver cualquier duda. Nuestro equipo está listo para asistirte y asegurarte una experiencia óptima. Consulta nuestras guías, preguntas frecuentes (FAQs) y opciones de contacto.',
                    style: TextStyle(fontSize: responsive.dp(1.8)),
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.hp(2)),
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(responsive.dp(4)),
                topRight: Radius.circular(responsive.dp(4)),
              ),
              child: Container(
                width: double.infinity,
                color: const Color.fromRGBO(6, 66, 106, 1),
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Correo',
                      style: TextStyle(
                        fontSize: responsive.dp(2.5),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsive.hp(1)),
                    Text(
                      'UniPass.Soporte@ulv.edu.mx',
                      style: TextStyle(
                        fontSize: responsive.dp(2),
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsive.hp(2)),
                    Text(
                      'Dirección',
                      style: TextStyle(
                        fontSize: responsive.dp(2.5),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsive.hp(1)),
                    Text(
                      'Ex-Finca Santa Cruz Nº 1, CP 29750, Pueblo Nuevo Solistahuacán, Chiapas, México. En las oficinas de Vicerrectoría Estudiantil',
                      style: TextStyle(
                        fontSize: responsive.dp(2),
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsive.hp(2)),
                    Text(
                      'Teléfono',
                      style: TextStyle(
                        fontSize: responsive.dp(2.5),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsive.hp(1)),
                    Text(
                      '+52 919 685 2100',
                      style: TextStyle(
                        fontSize: responsive.dp(2),
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsive.hp(4)),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Lógica para descargar manual
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(250, 198, 0, 1),
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(10),
                            vertical: responsive.hp(2),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(responsive.dp(2)),
                          ),
                        ),
                        child: Text(
                          'Descargar Manual',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: responsive.dp(2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: responsive.hp(4)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
