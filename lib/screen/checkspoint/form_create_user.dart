import 'package:flutter/material.dart';
import 'package:flutter_application_unipass/services/register_service.dart';
import 'package:flutter_application_unipass/services/user_checkers_service.dart';
import 'package:flutter_application_unipass/utils/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateUserChecks extends StatefulWidget {
  static const RouteName = '/CreateUserChecks';
  const CreateUserChecks({super.key});

  @override
  State<CreateUserChecks> createState() => _CreateUserChecksState();
}

class _CreateUserChecksState extends State<CreateUserChecks> {
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
    'H.S.N.M.',
    'H.S.N.U.',
    'H.V.N.M.',
    'H.V.N.U.',
    'Vigilancia'
  ];
  final UserCheckersService _userCheckersService = UserCheckersService();
  List<dynamic> _checkers = []; // Lista para almacenar los checkers
  bool _isLoading = false; // Indicador de carga

  void _addUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? correo = prefs.getString('correo');

    // Validar el formulario antes de proceder
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Guarda los valores del formulario

      if (matricula == null || matricula!.isEmpty) {
        // Mostrar un error si la matrícula es nula o vacía
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La matrícula no puede estar vacía')),
        );
        return;
      }

      // Asegurarse de que el prefijo sea correcto
      String user = "MTR$matricula";

      final registerService = RegisterService();

      // Convertir el género seleccionado a 'M' o 'F'
      String genderValue = gender == 'Hombre' ? 'M' : 'F';

      // Convertir el departamento seleccionado a su valor numérico
      int departmentValue;
      switch (department) {
        case 'H.S.N.M.':
          departmentValue = 1;
          break;
        case 'H.S.N.U.':
          departmentValue = 2;
          break;
        case 'H.V.N.M.':
          departmentValue = 3;
          break;
        case 'H.V.N.U.':
          departmentValue = 4;
          break;
        case 'Vigilancia':
          departmentValue = 6;
          break;
        default:
          departmentValue = 6;
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
        matricula = null; // Restablecer la matrícula

        // Mostrar un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado exitosamente')),
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

  Future<void> _fetchCheckers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? correo =
        prefs.getString('correo'); // Obtén el correo del usuario actual

    if (correo == null || correo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No se encontró un correo en preferencias')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final checkers = await _userCheckersService.buscarChecker(correo);
      setState(() {
        _checkers = [
          checkers
        ]; // Asegúrate de manejar un objeto o lista, según tu API
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar checkers: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                          labelStyle: TextStyle(
                              fontSize: responsive.dp(1.8),
                              color: Colors.grey[700]),
                          hintText: 'Ingresa tu nombre',
                          hintStyle: TextStyle(
                              fontSize: responsive.dp(1.6),
                              color: Colors.grey[500]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(6, 66, 106, 1)),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          prefixIcon: const Icon(Icons.person,
                              color: Color.fromRGBO(6, 66, 106, 1)),
                        ),
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
                      SizedBox(height: responsive.hp(2)),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Apellido',
                          labelStyle: TextStyle(
                            fontSize: responsive.dp(1.8),
                            color:
                                Colors.grey[700], // Color del texto del label
                          ),
                          hintText:
                              'Ingresa tu apellido', // Texto de sugerencia
                          hintStyle: TextStyle(
                            fontSize: responsive.dp(1.6),
                            color: Colors
                                .grey[500], // Color del texto de sugerencia
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Bordes redondeados
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(6, 66, 106, 1)),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100], // Color de fondo
                          prefixIcon: const Icon(
                            Icons.person_outline, // Icono al inicio del campo
                            color: Color.fromRGBO(6, 66, 106, 1),
                          ),
                        ),
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
                      SizedBox(height: responsive.hp(2)),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Género',
                          labelStyle: TextStyle(
                              fontSize: responsive.dp(1.8),
                              color: Colors.grey[700]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(6, 66, 106, 1)),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          prefixIcon: const Icon(Icons.male,
                              color: Color.fromRGBO(6, 66, 106, 1)),
                        ),
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
                            return 'Selecciona un género';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: responsive.hp(2)),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Celular',
                          labelStyle: TextStyle(
                              fontSize: responsive.dp(1.8),
                              color: Colors.grey[700]),
                          hintText: 'Ingresa tu número de celular',
                          hintStyle: TextStyle(
                              fontSize: responsive.dp(1.6),
                              color: Colors.grey[500]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(6, 66, 106, 1)),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          prefixIcon: const Icon(Icons.phone,
                              color: Color.fromRGBO(6, 66, 106, 1)),
                        ),
                        keyboardType: TextInputType.phone,
                        onSaved: (value) {
                          phoneNumber = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa un número celular';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: responsive.hp(2)),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Lugar de control',
                          labelStyle: TextStyle(
                            fontSize: responsive.dp(1.8),
                            color:
                                Colors.grey[700], // Color del texto del label
                          ),
                          hintText:
                              'Selecciona un lugar', // Texto de sugerencia
                          hintStyle: TextStyle(
                            fontSize: responsive.dp(1.6),
                            color: Colors
                                .grey[500], // Color del texto de sugerencia
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Bordes redondeados
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(6, 66, 106, 1)),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100], // Fondo suave
                          prefixIcon: const Icon(
                            Icons.location_on, // Icono al inicio del campo
                            color: Color.fromRGBO(6, 66, 106, 1),
                          ),
                        ),
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
                            return 'Selecciona el lugar de control';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: responsive.hp(2)),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Matrícula del personal a asignar',
                          labelStyle: TextStyle(
                            fontSize: responsive.dp(1.8),
                            color: Colors.grey[700],
                          ),
                          hintText: 'Ingresa la matrícula',
                          hintStyle: TextStyle(
                            fontSize: responsive.dp(1.6),
                            color: Colors.grey[500],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(6, 66, 106, 1)),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          prefixIcon: const Icon(
                            Icons.assignment_ind, // Icono al inicio
                            color: Color.fromRGBO(6, 66, 106, 1),
                          ),
                        ),
                        onSaved: (value) {
                          matricula = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresar la matrícula a asignar';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: responsive.hp(2)),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: TextStyle(
                            fontSize: responsive.dp(1.8),
                            color: Colors.grey[700],
                          ),
                          hintText: 'Ingresa la contraseña',
                          hintStyle: TextStyle(
                            fontSize: responsive.dp(1.6),
                            color: Colors.grey[500],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(6, 66, 106, 1)),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          prefixIcon: const Icon(
                            Icons.lock_outline, // Icono al inicio
                            color: Color.fromRGBO(6, 66, 106, 1),
                          ),
                        ),
                        obscureText: true, // Contraseña oculta
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
                      SizedBox(
                        width: responsive.wp(60), // Ancho del botón
                        child: ElevatedButton(
                          onPressed: _addUser, // Acción que realiza el botón
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(
                                250, 198, 0, 1), // Color de fondo
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    responsive.hp(1.6)), // Padding interno
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  responsive.wp(10)), // Bordes redondeados
                            ),
                          ),
                          child: Text(
                            'Crear usuario', // Texto del botón
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: responsive.dp(2), // Tamaño del texto
                              fontWeight: FontWeight.w700, // Negrita
                              color: Colors.white, // Color del texto
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: responsive.hp(1.4)),
                //SizedBox(
                //  height: 300, // Especifica una altura que consideres adecuada
                //  child: ListView.builder(
                //    itemCount: _users.length,
                //    itemBuilder: (context, index) {
                //      final user = _users[index];
                //      return Dismissible(
                //        key: Key(user['Celular']),
                //        direction: DismissDirection.startToEnd,
                //        onDismissed: (direction) {
                //          _deleteUser(index);
                //        },
                //        background: Container(
                //          color: Colors.red,
                //          alignment: Alignment.centerLeft,
                //          padding: const EdgeInsets.symmetric(horizontal: 20),
                //          child: const Icon(Icons.delete, color: Colors.white),
                //        ),
                //        child: ListTile(
                //          title: Text('${user['Nombre']} ${user['Apellidos']}'),
                //          subtitle: Text(
                //              'Gender: ${user['Sexo']} - Phone: ${user['Celular']} - Usuario: ${user['Matricula']} - Password: ${user['Contraseña']}'),
                //        ),
                //      );
                //    },
                //  ),
                //),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
