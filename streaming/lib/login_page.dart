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
          _responseMessage = "Registro exitoso. Token: $token";
        });
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
          _responseMessage = "Inicio de sesión exitoso. Token: $token";
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
      appBar: AppBar(title: Text("Autenticación")),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "Registro"),
              Tab(text: "Iniciar Sesión"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Pestaña de Registro
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _registerFormKey,
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: _registerUsernameController,
                          decoration: InputDecoration(labelText: "Correo"),
                          validator: (value) =>
                              value!.isEmpty ? "El correo es requerido" : null,
                        ),
                        TextFormField(
                          controller: _registerPasswordController,
                          decoration: InputDecoration(labelText: "Contraseña"),
                          obscureText: true,
                          validator: (value) => value!.isEmpty
                              ? "La contraseña es requerida"
                              : null,
                        ),
                        TextFormField(
                          controller: _lastnameController,
                          decoration: InputDecoration(labelText: "Apellido"),
                          validator: (value) => value!.isEmpty
                              ? "El apellido es requerido"
                              : null,
                        ),
                        TextFormField(
                          controller: _firstnameController,
                          decoration: InputDecoration(labelText: "Nombre"),
                          validator: (value) =>
                              value!.isEmpty ? "El nombre es requerido" : null,
                        ),
                        TextFormField(
                          controller: _countryController,
                          decoration: InputDecoration(labelText: "País"),
                          validator: (value) =>
                              value!.isEmpty ? "El país es requerido" : null,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _registerUser,
                          child: Text("Registrar"),
                        ),
                      ],
                    ),
                  ),
                ),
                // Pestaña de Inicio de Sesión
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _loginFormKey,
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: _loginUsernameController,
                          decoration: InputDecoration(labelText: "Correo"),
                          validator: (value) =>
                              value!.isEmpty ? "El correo es requerido" : null,
                        ),
                        TextFormField(
                          controller: _loginPasswordController,
                          decoration: InputDecoration(labelText: "Contraseña"),
                          obscureText: true,
                          validator: (value) => value!.isEmpty
                              ? "La contraseña es requerida"
                              : null,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _loginUser,
                          child: Text("Iniciar Sesión"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_responseMessage != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _responseMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
