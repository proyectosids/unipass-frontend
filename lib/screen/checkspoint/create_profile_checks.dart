import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/services/register_service.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateProfileChecks extends StatefulWidget {
  static const RouteName = '/NewProfileChecks';
  const CreateProfileChecks({super.key});

  @override
  State<CreateProfileChecks> createState() => _CreateProfileChecksState();
}

class _CreateProfileChecksState extends State<CreateProfileChecks> {
  final List<Map<String, dynamic>> _users = [];
  final _formKey = GlobalKey<FormState>();

  String? matricula;
  String? name;
  String? surname;
  String? gender;
  String? phoneNumber;
  String? department;
  String? password;
  final String usertype = 'DEPARTAMENTO';

  final List<String> _genders = ['Hombre', 'Mujer'];
  final List<String> _dormitories = [
    'H.V.N.M.',
    'H.V.N.U.',
    'H.S.N.M.',
    'H.S.N.U.',
    'Vigilancia'
  ];

  void _addUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? correo = prefs.getString('correo');
    String? user = "MTR$matricula";
    final registerService = RegisterService();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Convertir el género seleccionado a 'M' o 'F'
      String genderValue = gender == 'Hombre' ? 'M' : 'F';

      // Convertir el departamento seleccionado a su valor numérico
      int departmentValue;
      switch (department) {
        case 'H.V.N.M.':
          departmentValue = 1;
          break;
        case 'H.V.N.U.':
          departmentValue = 2;
          break;
        case 'H.S.N.M.':
          departmentValue = 3;
          break;
        case 'H.S.N.U.':
          departmentValue = 4;
          break;
        case 'Vigilancia':
          departmentValue = 0;
          break;
        default:
          departmentValue = 0;
      }

      // Asignar la fecha en la que se crea
      String createDate = DateTime.now().toIso8601String(); // Formato ISO 8601

      // Crear un mapa con los datos del usuario
      final userData = {
        'Matricula': user,
        'Contraseña': password,
        'Correo': correo,
        'Nombre': name,
        'Apellidos': surname,
        'TipoUser': usertype,
        'Sexo': genderValue,
        'FechaNacimiento': createDate,
        'Celular': phoneNumber,
        'Dormitorio': departmentValue,
      };

      try {
        // Registrar el usuario en la base de datos
        await registerService.registerUser(userData);

        // Si el registro fue exitoso, agregar el usuario a la lista local
        setState(() {
          _users.add(userData);
        });

        // Resetear el formulario
        _formKey.currentState!.reset();

        // Mostrar un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario registrado exitosamente')),
        );
      } catch (error) {
        // Mostrar un mensaje de error si el registro falla
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar usuario: $error')),
        );
      }
    }
  }

  void _deleteUser(int index) {
    setState(() {
      _users.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double padding = responsive.wp(3);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Asignar Usuario',
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
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(padding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Nombre',
                            labelStyle:
                                TextStyle(fontSize: responsive.dp(1.8))),
                        onSaved: (value) {
                          name = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresar un nombre';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Apellido',
                            labelStyle:
                                TextStyle(fontSize: responsive.dp(1.8))),
                        onSaved: (value) {
                          surname = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresar un apellido';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            labelText: 'Género',
                            labelStyle:
                                TextStyle(fontSize: responsive.dp(1.8))),
                        items: _genders.map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (value) {
                          gender = value;
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Seleciona un género';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Celular',
                            labelStyle:
                                TextStyle(fontSize: responsive.dp(1.8))),
                        keyboardType: TextInputType.phone,
                        onSaved: (value) {
                          phoneNumber = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa un numero celular';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            labelText: 'Lugar de control',
                            labelStyle:
                                TextStyle(fontSize: responsive.dp(1.8))),
                        items: _dormitories.map((String dormitory) {
                          return DropdownMenuItem<String>(
                            value: dormitory,
                            child: Text(dormitory),
                          );
                        }).toList(),
                        onChanged: (value) {
                          department = value;
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Seleciona el lugar de control';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Matricula del personal ha asignar',
                            labelStyle:
                                TextStyle(fontSize: responsive.dp(1.8))),
                        onSaved: (value) {
                          matricula = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresar la matricula a asignar';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle:
                                TextStyle(fontSize: responsive.dp(1.8))),
                        obscureText: true,
                        onSaved: (value) {
                          password = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa una contraseña';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: responsive.hp(3)),
                      ElevatedButton(
                        onPressed: _addUser,
                        child: Text(
                          'Crear usuario',
                          style: TextStyle(fontSize: responsive.dp(1.8)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: responsive.hp(1.4)),
                SizedBox(
                  height: 300, // Especifica una altura que consideres adecuada
                  child: ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return Dismissible(
                        key: Key(user['Celular']),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          _deleteUser(index);
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ListTile(
                          title: Text('${user['Nombre']} ${user['Apellidos']}'),
                          subtitle: Text(
                              'Gender: ${user['Sexo']} - Phone: ${user['Celular']} - Usuario: ${user['Matricula']} - Password: ${user['Contraseña']}'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
