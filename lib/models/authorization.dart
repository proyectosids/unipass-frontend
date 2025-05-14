class Authorization {
  final int idAuthorize;
  final int idEmpleado;
  final int noDepto;
  final int idPermission;
  final String statusAuthorize;

  Authorization({
    required this.idAuthorize,
    required this.idEmpleado,
    required this.noDepto,
    required this.idPermission,
    required this.statusAuthorize,
  });

  factory Authorization.fromJson(Map<String, dynamic> json) {
    return Authorization(
      idAuthorize: json['IdAuthorize'],
      idEmpleado: json['IdEmpleado'],
      noDepto: json['NoDepto'],
      idPermission: json['IdPermission'],
      statusAuthorize: json['StatusAuthorize'],
    );
  }
}
