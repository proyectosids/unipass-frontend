class Permission {
  final int id;
  final DateTime fechasolicitud;
  final String statusPermission;
  final DateTime fechasalida;
  final DateTime fecharegreso;
  final String motivo;
  final int idlogin;
  final int idsalida;
  final String observaciones;
  final String descripcion;
  final String nombre;
  final String apellidos;
  final String contacto;
  final String trabajo;
  final String jefetrabajo;
  final String nombretutor;
  final String apellidotutor;
  final String moviltutor;
  final String matricula;
  final String correo;
  final String tipoUser;
  final String sexo;
  final DateTime fechaNacimiento;
  final String celular;

  Permission({
    required this.id,
    required this.fechasolicitud,
    required this.statusPermission,
    required this.fechasalida,
    required this.fecharegreso,
    required this.motivo,
    required this.idlogin,
    required this.idsalida,
    required this.observaciones,
    required this.descripcion,
    required this.nombre,
    required this.apellidos,
    required this.contacto,
    required this.trabajo,
    required this.jefetrabajo,
    required this.nombretutor,
    required this.apellidotutor,
    required this.moviltutor,
    required this.matricula,
    required this.correo,
    required this.tipoUser,
    required this.sexo,
    required this.fechaNacimiento,
    required this.celular,
  });

  factory Permission.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> userJson) {
    return Permission(
      id: json['IdPermission'] ?? 0,
      fechasolicitud:
          DateTime.tryParse(json['FechaSolicitada'] ?? '') ?? DateTime(1900),
      statusPermission: json['StatusPermission'] ?? '',
      fechasalida:
          DateTime.tryParse(json['FechaSalida'] ?? '') ?? DateTime(1900),
      fecharegreso:
          DateTime.tryParse(json['FechaRegreso'] ?? '') ?? DateTime(1900),
      motivo: json['Motivo'] ?? '',
      idlogin: json['IdLogin'] ?? 0,
      idsalida: json['IdTipoSalida'] ?? 0,
      observaciones: json['Observaciones'] ?? '',
      descripcion: json['Descripcion'] ?? '',
      nombre: json['Nombre'] ?? '',
      apellidos: json['Apellidos'] ?? '',
      contacto: userJson['student'] != null && userJson['student'].isNotEmpty
          ? (userJson['student'][0]['CELULAR'] ?? '')
          : '',
      trabajo: userJson['work'] != null && userJson['work'].isNotEmpty
          ? (userJson['work'][0]['DEPARTAMENTO'] ?? '')
          : '',
      jefetrabajo: userJson['work'] != null && userJson['work'].isNotEmpty
          ? (userJson['work'][0]['JEFE DEPARTAMENTO'] ?? '')
          : '',
      nombretutor: userJson['Tutor'] != null && userJson['Tutor'].isNotEmpty
          ? (userJson['Tutor'][0]['NOMBRE_TUTOR'] ?? '')
          : '',
      apellidotutor: userJson['Tutor'] != null && userJson['Tutor'].isNotEmpty
          ? (userJson['Tutor'][0]['APELLIDOS_TUTOR'] ?? '')
          : '',
      moviltutor: userJson['Tutor'] != null && userJson['Tutor'].isNotEmpty
          ? (userJson['Tutor'][0]['MOVIL_TUTOR'] ?? '')
          : '',
      matricula: userJson['student'] != null && userJson['student'].isNotEmpty
          ? (userJson['student'][0]['MATRICULA'] ?? '')
          : '',
      correo: json['Correo'] ?? '',
      tipoUser: json['TipoUser'] ?? '',
      sexo: json['Sexo'] ?? '',
      fechaNacimiento:
          DateTime.tryParse(json['FechaNacimiento'] ?? '') ?? DateTime(1900),
      celular: json['Celular'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IdPermission': id,
      'FechaSolicitada': fechasolicitud.toIso8601String(),
      'StatusPermission': statusPermission,
      'FechaSalida': fechasalida.toIso8601String(),
      'FechaRegreso': fecharegreso.toIso8601String(),
      'Motivo': motivo,
      'IdLogin': idlogin,
      'IdTipoSalida': idsalida,
      'Observaciones': observaciones,
      'Descripcion': descripcion,
      'Nombre': nombre,
      'Apellidos': apellidos,
      'CELULAR': contacto,
      'Departamento': trabajo,
      'JEFE DEPARTAMENTO': jefetrabajo,
      'NOMBRE_TUTOR': nombretutor,
      'APELLIDOS_TUTOR': apellidotutor,
      'MOVIL_TUTOR': moviltutor,
      'MATRICULA': matricula,
      'Correo': correo,
      'TipoUser': tipoUser,
      'Sexo': sexo,
      'FechaNacimiento': fechaNacimiento.toIso8601String(),
      'Celular': celular,
    };
  }
}
