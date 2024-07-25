class Student {
  final String matricula;
  final String nombre;
  final String apellidos;
  final DateTime fechaNacimiento;
  final String sexo;
  final int edad;
  final String telFijo;
  final String celular;
  final String correoPersonal;
  final String correoInstitucional;
  final String pais;
  final String estado;
  final String ciudad;
  final String direccion;
  final String cp;
  final String curp;
  final String nivelAcademico;
  final String campus;
  final String nombreEscuela;
  final String cursoEscolar;

  Student({
    required this.matricula,
    required this.nombre,
    required this.apellidos,
    required this.fechaNacimiento,
    required this.sexo,
    required this.edad,
    required this.telFijo,
    required this.celular,
    required this.correoPersonal,
    required this.correoInstitucional,
    required this.pais,
    required this.estado,
    required this.ciudad,
    required this.direccion,
    required this.cp,
    required this.curp,
    required this.nivelAcademico,
    required this.campus,
    required this.nombreEscuela,
    required this.cursoEscolar,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      matricula: json['MATRICULA'] ?? '',
      nombre: json['NOMBRE'] ?? '',
      apellidos: json['APELLIDOS'] ?? '',
      fechaNacimiento: DateTime.parse(json['FECHA_NACIMIENTO'] ?? '1900-01-01'),
      sexo: json['SEXO'] ?? '',
      edad: json['EDAD'] ?? 0,
      telFijo: json['TEL_FIJO'] ?? '',
      celular: json['CELULAR'] ?? '',
      correoPersonal: json['CORREO_PERSONAL'] ?? '',
      correoInstitucional: json['CORREO_INSTITUCIONAL'] ?? '',
      pais: json['PAIS'] ?? '',
      estado: json['ESTADO'] ?? '',
      ciudad: json['CIUDAD'] ?? '',
      direccion: json['DIRECCION'] ?? '',
      cp: json['CP'] ?? '',
      curp: json['CURP'] ?? '',
      nivelAcademico: json['NIVEL_EDUCATIVO'] ?? '',
      campus: json['CAMPO'] ?? '',
      nombreEscuela: json['LeNombreEscuelaOficial'] ?? '',
      cursoEscolar: json['CURSO_ESCOLAR'] ?? '',
    );
  }
}

class Tutor {
  final String nombre;
  final String apellidos;
  final String telefono;
  final String direccion;
  final String pais;
  final String estado;
  final String ciudad;
  final String cp;
  final String celular;
  final String correo;

  Tutor({
    required this.nombre,
    required this.apellidos,
    required this.telefono,
    required this.direccion,
    required this.pais,
    required this.estado,
    required this.ciudad,
    required this.cp,
    required this.celular,
    required this.correo,
  });

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      nombre: json['NOMBRE_TUTOR'] ?? '',
      apellidos: json['APELLIDOS_TUTOR'] ?? '',
      telefono: json['TELETONO_TUTOR'] ?? '',
      direccion: json['DIRECCION_TUTOR'] ?? '',
      pais: json['PAIS_TUTOR'] ?? '',
      estado: json['ESTADO_TUTOR'] ?? '',
      ciudad: json['CIUDAD_TUTOR'] ?? '',
      cp: json['CP_TUTOR'] ?? '',
      celular: json['MOVIL_TUTOR'] ?? '',
      correo: json['EMAIL_TUTOR'] ?? '',
    );
  }
}

class Work {
  final String jefeDepartamento;
  final String nombreDepartamento;

  Work({
    required this.jefeDepartamento,
    required this.nombreDepartamento,
  });

  factory Work.fromJson(Map<String, dynamic> json) {
    return Work(
      jefeDepartamento: json['JEFE DEPARTAMENTO'] ?? '',
      nombreDepartamento: json['DEPARTAMENTO'] ?? '',
    );
  }
}

class Employee {
  final int matricula;
  final String campus;
  final String nombres;
  final String apellidos;
  final DateTime fechaNacimiento;
  final int edad;
  final String sexo;
  final String celular;
  final String emailInstitucional;
  final int idDepartamento;
  final String departamento;

  Employee({
    required this.matricula,
    required this.campus,
    required this.nombres,
    required this.apellidos,
    required this.fechaNacimiento,
    required this.edad,
    required this.sexo,
    required this.celular,
    required this.emailInstitucional,
    required this.idDepartamento,
    required this.departamento,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      matricula: json['MATRICULA'] ?? 0,
      campus: json['CAMPUS'] ?? '',
      nombres: json['NOMBRES'] ?? '',
      apellidos: json['APELLIDOS'] ?? '',
      fechaNacimiento: DateTime.parse(json['FECHA_NACIMIENTO'] ?? '1900-01-01'),
      edad: json['EDAD'] ?? 0,
      sexo: json['SEXO'] ?? '',
      celular: json['CELULAR'] ?? '',
      emailInstitucional: json['EMAIl_INSTITUCIONAL'] ?? '',
      idDepartamento: json['ID_DEPARATAMENTO'] ?? 0,
      departamento: json['DEPARTAMENTO'] ?? '',
    );
  }
}

class UserData {
  final List<Student>? students;
  final String type;
  final List<Tutor>? tutors;
  final List<Work>? works;
  final List<Employee>? employees;

  UserData({
    this.students,
    required this.type,
    this.tutors,
    this.works,
    this.employees,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      students: (json['student'] as List<dynamic>?)
          ?.map((i) => Student.fromJson(i))
          .toList(),
      type: json['type'] ?? '',
      tutors: (json['Tutor'] as List<dynamic>?)
          ?.map((i) => Tutor.fromJson(i))
          .toList(),
      works: (json['work'] as List<dynamic>?)
          ?.map((i) => Work.fromJson(i))
          .toList(),
      employees: (json['employee'] as List<dynamic>?)
          ?.map((i) => Employee.fromJson(i))
          .toList(),
    );
  }
}
