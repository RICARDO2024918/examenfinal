import 'package:flutter/material.dart';
import 'package:streaming/administrador_secion.dart';
import 'package:streaming/inicio.dart';

void main() {
  runApp(MyApp());
}

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Usuario',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

const darkBlueColor = Color(0xff486579); //App theme

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enter Person details - CURD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primaryColor: Colors.orange,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Enter Person details - CURD'),
    );
  }
}

//Add home page
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required String title}) : super(key: key);

  String get title => "Enter Person details - CURD";

  @override
  State<MyHomePage> createState() => AdministradorSecion();
}
