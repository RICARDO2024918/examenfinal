import 'package:flutter/material.dart';
import 'package:streaming/api_servicce.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _apiService = ApiService();
  late TabController _tabController;

  final _registerFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();

  // Controladores para Registro
  final TextEditingController _registerUsernameController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  // Controladores para Login
  final TextEditingController _loginUsernameController =
      TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

  String? _responseMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _registerUsernameController.dispose();
    _registerPasswordController.dispose();
    _lastnameController.dispose();
    _firstnameController.dispose();
    _countryController.dispose();
    _loginUsernameController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  void _registerUser() async {
    if (_registerFormKey.currentState!.validate()) {
      final userData = {
        "username": _registerUsernameController.text,
        "password": _registerPasswordController.text,
        "lastname": _lastnameController.text,
        "firstname": _firstnameController.text,
        "country": _countryController.text,
      };

      try {
        final token = await _apiService.registerUser(userData);
        setState(() {
          _responseMessage =
              "Registro exitoso. ¡Bienvenido a nuestra plataforma de streaming! Diríjase a Inicio de Sesión.";
        });

        _registerUsernameController.clear();
        _registerPasswordController.clear();
        _lastnameController.clear();
        _firstnameController.clear();
        _countryController.clear();
      } catch (e) {
        setState(() {
          _responseMessage = e.toString();
        });
      }
    }
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
        title: Text(
          "Bienvenido a Video Streaming",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.deepPurple,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.amber,
              tabs: [
                Tab(icon: Icon(Icons.app_registration), text: "Registro"),
                Tab(icon: Icon(Icons.login), text: "Iniciar Sesión"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Pestaña de Registro
                _buildRegistrationForm(),
                // Pestaña de Inicio de Sesión
                _buildLoginForm(),
              ],
            ),
          ),
          if (_responseMessage != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _responseMessage!,
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _registerFormKey,
        child: ListView(
          children: [
            Text(
              "Cree su cuenta",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _buildTextField(_registerUsernameController, "Correo Electrónico",
                Icons.email, "El correo es requerido"),
            _buildTextField(
              _registerPasswordController,
              "Contraseña",
              Icons.lock,
              "La contraseña es requerida",
              isPassword: true,
            ),
            _buildTextField(_firstnameController, "Nombre", Icons.person,
                "El nombre es requerido"),
            _buildTextField(_lastnameController, "Apellido", Icons.person,
                "El apellido es requerido"),
            _buildTextField(_countryController, "País", Icons.public,
                "El país es requerido"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: const Color.fromARGB(255, 41, 10,
                    10), // Cambia el texto a blanco o cualquier color deseado
              ),
              child: Text("Registrar"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _loginFormKey,
        child: ListView(
          children: [
            Text(
              "Inicie Sesión",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _buildTextField(_loginUsernameController, "Correo Electrónico",
                Icons.email, "El correo es requerido"),
            _buildTextField(
              _loginPasswordController,
              "Contraseña",
              Icons.lock,
              "La contraseña es requerida",
              isPassword: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: const Color.fromARGB(255, 41, 10,
                    10), // Cambia el texto a blanco o cualquier color deseado
              ),
              child: Text("Iniciar Sesión"),
            ),
          ],
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
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          border: OutlineInputBorder(),
        ),
        obscureText: isPassword,
        validator: (value) => value!.isEmpty ? validationMessage : null,
      ),
    );
  }
}
