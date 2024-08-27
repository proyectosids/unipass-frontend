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
    }
    if (userData.works != null && userData.works!.isNotEmpty) {
      Work work = userData.works!.first;
      await prefs.setInt('idDepto', work.idDepto);
      await prefs.setString('nombreDepartamento', work.nombreDepartamento);
      await prefs.setInt('idJefe', work.idJefe);
      await prefs.setString('trabajo', work.jefeDepartamento);
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
  }
}
