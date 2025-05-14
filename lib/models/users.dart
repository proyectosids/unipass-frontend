class Student {
  final String matricula;
  final String nombre;
  final String apellidos;
  final String residencia;
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
    required this.residencia,
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
      residencia: json['RESIDENCIA'],
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

  Map<String, dynamic> toJson() {
    return {
      'MATRICULA': matricula,
      'NOMBRE': nombre,
      'APELLIDOS': apellidos,
      'RESIDENCIA': residencia,
      'FECHA_NACIMIENTO': fechaNacimiento.toIso8601String(),
      'SEXO': sexo,
      'EDAD': edad,
      'TEL_FIJO': telFijo,
      'CELULAR': celular,
      'CORREO_PERSONAL': correoPersonal,
      'CORREO_INSTITUCIONAL': correoInstitucional,
      'PAIS': pais,
      'ESTADO': estado,
      'CIUDAD': ciudad,
      'DIRECCION': direccion,
      'CP': cp,
      'CURP': curp,
      'NIVEL_EDUCATIVO': nivelAcademico,
      'CAMPO': campus,
      'LeNombreEscuelaOficial': nombreEscuela,
      'CURSO_ESCOLAR': cursoEscolar,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'NOMBRE_TUTOR': nombre,
      'APELLIDOS_TUTOR': apellidos,
      'TELETONO_TUTOR': telefono,
      'DIRECCION_TUTOR': direccion,
      'PAIS_TUTOR': pais,
      'ESTADO_TUTOR': estado,
      'CIUDAD_TUTOR': ciudad,
      'CP_TUTOR': cp,
      'MOVIL_TUTOR': celular,
      'EMAIL_TUTOR': correo,
    };
  }
}

class Work {
  final int idDepto;
  final String nombreDepartamento;
  final int idJefe;
  final String jefeDepartamento;

  Work({
    required this.idDepto,
    required this.nombreDepartamento,
    required this.idJefe,
    required this.jefeDepartamento,
  });

  factory Work.fromJson(Map<String, dynamic> json) {
    return Work(
      idDepto: json['ID DEPTO'] ?? '',
      nombreDepartamento: json['DEPARTAMENTO'] ?? '',
      idJefe: json['ID JEFE'] ?? '',
      jefeDepartamento: json['JEFE DEPARTAMENTO'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID DEPTO': idDepto,
      'DEPARTAMENTO': nombreDepartamento,
      'ID JEFE': idJefe,
      'JEFE DEPARTAMENTO': jefeDepartamento,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'MATRICULA': matricula,
      'CAMPUS': campus,
      'NOMBRES': nombres,
      'APELLIDOS': apellidos,
      'FECHA_NACIMIENTO': fechaNacimiento.toIso8601String(),
      'EDAD': edad,
      'SEXO': sexo,
      'CELULAR': celular,
      'EMAIl_INSTITUCIONAL': emailInstitucional,
      'ID_DEPARATAMENTO': idDepartamento,
      'DEPARTAMENTO': departamento,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'student': students?.map((s) => s.toJson()).toList(),
      'type': type,
      'Tutor': tutors?.map((t) => t.toJson()).toList(),
      'work': works?.map((w) => w.toJson()).toList(),
      'employee': employees?.map((e) => e.toJson()).toList(),
    };
  }
}
