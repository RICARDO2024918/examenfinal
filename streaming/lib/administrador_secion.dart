import 'package:flutter/material.dart';
import 'package:streaming/login_page.dart'; // Asegúrate de que esta ruta sea correcta

class AdministradorSecion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo o imagen de bienvenida
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/imagen/logo.jpeg'), // Ruta de la imagen
              ),
              const SizedBox(height: 20),
              // Título de bienvenida
              const Text(
                'administracion de base de datos ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Trabajo de Pedrito .',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Texto adicional
            ],
          ),
        ),
      ),
    );
  }
}
