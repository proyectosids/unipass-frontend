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
  final String trabajo;
  final String contacto;

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
    required this.trabajo,
    required this.contacto,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['IdPermission'] ?? 0,
      fechasolicitud: json['FechaSolicitada'] ?? '',
      statusPermission: json['StatusPermission'] ?? '',
      fechasalida: json['FechaSalida'] ?? '',
      fecharegreso: json['FechaRegreso'] ?? '',
      motivo: json['Motivo'] ?? '',
      idlogin: json['IdLogin'] ?? '',
      idsalida: json['IdTipoSalida'] ?? '',
      observaciones: json['Observaciones'] ?? '',
      descripcion: json['Descripcion'] ?? '',
      nombre: json['Nombre'] ?? '',
      apellidos: json['Apellidos'] ?? '',
      trabajo: json['Trabajo'] ?? '',
      contacto: json['Celular'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IdPermission': id,
      'FechaSolicitada': fechasolicitud,
      'StatusPermission': statusPermission,
      'FechaSalida': fechasalida,
      'FechaRegreso': fecharegreso,
      'Motivo': motivo,
      'IdLogin': idlogin,
      'IdTipoSalida': idsalida,
      'Observaciones': observaciones,
      'Descripcion': descripcion,
      'Nombre': nombre,
      'Apellidos': apellidos,
      'Trabajo': trabajo,
      'Celular': contacto,
    };
  }
}
