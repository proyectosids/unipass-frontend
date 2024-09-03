import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_unipass/models/users.dart';

class AuthUtils {
  static const String _userIdKey = 'userId';
  static const String _tipoUserKey = 'tipoUser';

  static Future<void> saveTipoUser(String tipoUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tipoUserKey, tipoUser);
  }

  static Future<String?> getTipoUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tipoUserKey);
  }

  static Future<void> clearTipoUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tipoUserKey);
  }

  static Future<void> saveUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }

  static Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  static Future<void> clearUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }

  static Future<void> saveUserInfo(UserData userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userData.students != null && userData.students!.isNotEmpty) {
      Student student = userData.students!.first;
      await prefs.setString('nivelAcademico', student.nivelAcademico);
      await prefs.setString('sexo', student.sexo);
      await prefs.setString('matricula', student.matricula);
      await prefs.setString('nombre', student.nombre);
      await prefs.setString('apellidos', student.apellidos);
      await prefs.setString('correo', student.correoInstitucional);
    }
    if (userData.works != null && userData.works!.isNotEmpty) {
      Work work = userData.works!.first;
      await prefs.setInt('idDepto', work.idDepto);
      await prefs.setString('nombreDepartamento', work.nombreDepartamento);
      await prefs.setInt('idJefe', work.idJefe);
      await prefs.setString('trabajo', work.jefeDepartamento);
    }
    if (userData.employees != null && userData.employees!.isNotEmpty) {
      // Guardar información de empleados si no hay datos de estudiantes
      Employee employee = userData.employees!.first;
      await prefs.setString('sexo', employee.sexo);
      await prefs.setString('matricula', employee.matricula.toString());
      await prefs.setString('nombreDepartamento', employee.departamento);
      await prefs.setString('nombre', employee.nombres);
      await prefs.setString('apellidos', employee.apellidos);
      await prefs.setString('correo', employee.emailInstitucional);
    }
  }

  static Future<String?> getTrabajo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('trabajo');
  }

  static Future<void> clearUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('nivelAcademico');
    await prefs.remove('sexo');
    await prefs.remove('matricula');
    await prefs.remove('idDepto');
    await prefs.remove('nombreDepartamento');
    await prefs.remove('idJefe');
    await prefs.remove('trabajo');
    await prefs.remove('nombre');
    await prefs.remove('apellidos');
  }
}
