import 'package:flutter/material.dart';
import 'package:streaming/api_servicce.dart';
import 'package:streaming/home_page.dart';
import 'administrador_secion.dart';

class AdministradorPage extends StatefulWidget {
  @override
  _AdministradorPageState createState() => _AdministradorPageState();
}

class _AdministradorPageState extends State<AdministradorPage>
    with SingleTickerProviderStateMixin {
  final _apiService = ApiService();
  final _loginFormKey = GlobalKey<FormState>();

  final TextEditingController _loginUsernameController =
      TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

  String? _responseMessage;

  @override
  void dispose() {
    _loginUsernameController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  void _loginUser() async {
    if (_loginFormKey.currentState!.validate()) {
      final loginData = {
        "username": _loginUsernameController.text,
        "password": _loginPasswordController.text,
      };

      try {
        final token = await _apiService.loginUser(loginData);
        setState(() {
          _responseMessage =
              "Inicio de sesión exitoso. ¡Disfrute su contenido!";
        });

        // Redirige a la página de inicio (HomePage1)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdministradorSecion()),
        );
      } catch (e) {
        setState(() {
          _responseMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio de Sesión - Administrador"),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Acceso Administrativo",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _buildTextField(_loginUsernameController, "Usuario", Icons.person,
                  "El usuario es requerido"),
              _buildTextField(_loginPasswordController, "Contraseña",
                  Icons.lock, "La contraseña es requerida",
                  isPassword: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                child: Text("Iniciar Sesión"),
              ),
              if (_responseMessage != null) ...[
                SizedBox(height: 20),
                Text(
                  _responseMessage!,
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      IconData icon, String validationMessage,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: Colors.amber),
          border: OutlineInputBorder(),
        ),
        obscureText: isPassword,
        validator: (value) => value!.isEmpty ? validationMessage : null,
      ),
    );
  }
}
