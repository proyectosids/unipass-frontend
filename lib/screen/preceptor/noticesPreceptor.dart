import 'package:flutter/material.dart';

class NoticesScreenPreceptor extends StatefulWidget {
  static const routeName = '/noticePreceptor';
  const NoticesScreenPreceptor({super.key});

  @override
  State<NoticesScreenPreceptor> createState() => _NoticesScreenPreceptorState();
}

class _NoticesScreenPreceptorState extends State<NoticesScreenPreceptor> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  String? _directedTo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0), // Morado
        title: const Text(
          'Crear aviso',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Titulos del aviso*',
                    ),
                    onSaved: (value) {
                      _title = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Dirigido a',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Departamento de trabajo',
                        child: Text('Departamento de trabajo'),
                      ),
                      DropdownMenuItem(
                        value: 'Dormitorio',
                        child: Text('Dormitorio'),
                      ),
                      DropdownMenuItem(
                        value: 'General',
                        child: Text('General'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _directedTo = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Descripcion del aviso*',
                    ),
                    maxLines: 4,
                    onSaved: (value) {
                      _description = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();
                          final newNotice = {
                            'title': _title!,
                            'description': _description!,
                            'directedTo': _directedTo!,
                            'date':
                                'Ahora' // Puedes ajustar el formato de fecha según sea necesario
                          };
                          Navigator.of(context).pop(newNotice);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCDDC39), // Verde lima
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 32.0,
                        ),
                      ),
                      child: const Text(
                        'Crear aviso',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
