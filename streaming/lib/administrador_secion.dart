// Clase AdministradorSecion
import 'package:flutter/material.dart';
import 'package:streaming/model/Persons.dart';
import 'package:streaming/sql_helper.dart';

class AdministradorSecion extends StatefulWidget {
  @override
  _AdministradorSecionState createState() => _AdministradorSecionState();
}

class _AdministradorSecionState extends State<AdministradorSecion> {
  // Variables
  var id = "";
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  List<Person> _journals = [];
  bool _isLoading = true;

  // Inicialización
  @override
  void initState() {
    super.initState();
    _refreshPersonLists();
  }

  // Función para cargar datos
  void _refreshPersonLists() async {
    final data = await SQLHelper.getAllPersons();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  // Interfaz de usuario
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestión de Personas")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _form(),
                _listTitle(),
                Expanded(child: _personList()),
              ],
            ),
    );
  }

  // Formulario
  Widget _form() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Usuario"),
            ),
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(labelText: "Rol"),
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: "Pais"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (id.isEmpty) {
                  _addItem();
                } else {
                  _updateItem(id);
                }
                _clearFields();
              },
              child: Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }

  // Lista de personas
  Widget _personList() {
    return ListView.builder(
      itemCount: _journals.length,
      itemBuilder: (context, index) {
        final person = _journals[index];
        return ListTile(
          leading: Text(person.id ?? "Sin ID"), // Manejar posibles nulos
          title: Text(
              "${person.usuario ?? 'Sin nombre'} (${person.rol ?? 'N/A'})"),
          subtitle: Text(person.address ?? "Sin dirección"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    id =
                        person.id ?? ""; // Proporcionar un valor predeterminado
                    _nameController.text = person.usuario ?? "";
                    _ageController.text = person.rol ?? "";
                    _addressController.text = person.address ?? "";
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteItem(person.id ?? ""),
              ),
            ],
          ),
        );
      },
    );
  }

  // Título de la lista
  Widget _listTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Lista de Personas",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  // Métodos de base de datos
  Future<void> _addItem() async {
    await SQLHelper.insert(
      Person(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        usuario: _nameController.text,
        rol: _ageController.text,
        address: _addressController.text,
      ),
    );
    _refreshPersonLists();
  }

  Future<void> _updateItem(String id) async {
    await SQLHelper.update(
      id,
      _nameController.text,
      _ageController.text,
      _addressController.text,
    );
    _refreshPersonLists();
  }

  Future<void> _deleteItem(String id) async {
    await SQLHelper.deletePerson(id);
    _refreshPersonLists();
  }

  // Limpiar campos
  void _clearFields() {
    _nameController.clear();
    _ageController.clear();
    _addressController.clear();
    id = "";
  }
}
