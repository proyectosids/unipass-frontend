import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_unipass/models/users.dart';

class AuthUtils {
  static const String _userIdKey = 'userId';

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
      await prefs.setString('trabajo', work.jefeDepartamento);
      await prefs.setString('nombreDepartamento', work.nombreDepartamento);
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
    await prefs.remove('trabajo');
    await prefs.remove('nombreDepartamento');
  }
}
