import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String registerUrl = "http://192.168.1.6:8080/auth/register";
  final String loginUrl = "http://192.168.1.6:8080/auth/login";
  //final String registerUrl = "http://192.168.100.12:8080/auth/reister";
  //final String loginUrl = "http://192.168.100.12:8080/auth/login";

  Future<String> registerUser(Map<String, String> userData) async {
    try {
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token']; // Devuelve el token de registro
      } else {
        throw Exception("Error al registrar usuario: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error al conectar con el servidor: $e");
    }
  }

  Future<String> loginUser(Map<String, String> loginData) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(loginData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token']; // Devuelve el token de inicio de sesión
      } else {
        throw Exception("Error al iniciar sesión: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error al conectar con el servidor: $e");
    }
  }
}
