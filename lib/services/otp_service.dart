import 'package:flutter_application_unipass/config/config_url.dart';
import 'package:flutter_application_unipass/utils/imports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpServices {
  Future<void> loginOTP() async {
    final response = await http.post(
      Uri.parse('https://api-otp.app.syswork.online/api/v1/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
          {'email': "irving.patricio@ulv.edu.mx", 'password': "irya0904 "}),
    );
    if (response.statusCode == 200) {
      // Decodificar la respuesta JSON
      final responseData = json.decode(response.body);

      // Extraer el token de la respuesta
      final String token = responseData['token'];
      print(token);

      // Guardar el token en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      print("Logueado con éxito y token guardado.");
    } else {
      throw Exception('Failed to authenticate user');
    }
  }

  Future<void> launchOTP(String correo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('auth_token'); // Recupera el token almacenado

    if (token == null) {
      throw Exception('Token no disponible');
    }

    final response = await http.post(
      Uri.parse('https://api-otp.app.syswork.online/api/v1/otp_app'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
        'x-access-token': token, // Usamos el token recuperado
      },
      body: json.encode({
        'email': correo,
        'subject': 'Verificacion de Email',
        'message': 'Verifica tu email con el codigo de abajo',
        'duration': 1
      }),
    );

    if (response.statusCode == 200) {
      print("OTP enviado con éxito");
    } else {
      throw Exception('Failed to send OTP');
    }
  }

  Future<bool?> verificationOTP(String otp, String correo) async {
    final response = await http.post(
      Uri.parse('$otpUrl/api/v1/email_verification/verifyOTP'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': correo, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      print("OTP verificado con éxito");
      return true;
    } else {
      print('Failed to verify OTP');
      return false;
    }
  }

  Future<void> forgotOTP(String correo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('auth_token'); // Recupera el token almacenado

    if (token == null) {
      throw Exception('Token no disponible');
    }
    final response =
        await http.post(Uri.parse('$otpUrl/api/v1/forgot_password_app/'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
              'x-access-token': token, // Usamos el token recuperado
            },
            body: json.encode({'email': correo}));
    if (response.statusCode == 200) {
      print("OTP de recuperació enviado");
    } else {
      throw Exception('Failed to send OTP of forgot password');
    }
  }

  Future<bool> resetPassword(
      String correo, String otp, String newpassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('auth_token'); // Recupera el token almacenado

    if (token == null) {
      throw Exception('Token no disponible');
    }
    final response = await http.post(
        Uri.parse('$otpUrl/api/v1/forgot_password_app/reset'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
          'x-access-token': token, // Usamos el token recuperado
        },
        body: json
            .encode({'email': correo, 'otp': otp, 'newPassword': newpassword}));
    if (response.statusCode == 200) {
      print('OTP para cambio de contraseña valido');
      return true;
      //Regresar el password reset en el return de esta funcion para su porterio almacenamiento cuando la base datos unipasss este encryptada la contraseña.
    } else {
      print('Codigo OTP invalido');
      return false;
    }
  }
}
