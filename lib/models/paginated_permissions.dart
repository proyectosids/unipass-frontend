import 'package:flutter_application_unipass/models/permission.dart';

class PaginatedPermissions {
  final List<Permission> permissions;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int limit;

  PaginatedPermissions({
    required this.permissions,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
  });
}
