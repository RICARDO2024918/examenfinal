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
      appBar: AppBar(
        title: Text("Gestión de Personas"),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _form(),
                  _listTitle(),
                  _personList(),
                ],
              ),
            ),
      backgroundColor: Colors.grey[200],
    );
  }

  // Formulario
  Widget _form() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _styledTextField(
                controller: _nameController,
                label: "Usuario",
                icon: Icons.person,
              ),
              SizedBox(height: 10),
              _styledTextField(
                controller: _ageController,
                label: "Rol",
                icon: Icons.work_outline,
              ),
              SizedBox(height: 10),
              _styledTextField(
                controller: _addressController,
                label: "País",
                icon: Icons.location_on_outlined,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (id.isEmpty) {
                    _addItem();
                  } else {
                    _updateItem(id);
                  }
                  _clearFields();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[800],
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Guardar",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Campo de texto con estilo
  Widget _styledTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blueGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blueGrey[700]!),
        ),
      ),
    );
  }

  // Lista de personas
  Widget _personList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _journals.length,
      itemBuilder: (context, index) {
        final person = _journals[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey[700],
              child: Text(
                person.usuario?.substring(0, 1).toUpperCase() ?? "",
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              "${person.usuario ?? 'Sin nombre'}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${person.rol ?? 'N/A'} - ${person.address ?? ''}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blueGrey[700]),
                  onPressed: () {
                    setState(() {
                      id = person.id ?? "";
                      _nameController.text = person.usuario ?? "";
                      _ageController.text = person.rol ?? "";
                      _addressController.text = person.address ?? "";
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteItem(person.id ?? ""),
                ),
              ],
            ),
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
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.blueGrey[900],
        ),
        textAlign: TextAlign.center,
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
