///created the Modal Class of Person and their respective functions as shown below
class Person {
  final String? id;
  final String? usuario;
  final String? rol;
  final String? address;

  const Person({this.id, this.usuario, this.rol, this.address});

  //Alternate way to use model by const.
  //const Person({ this.id,  this.name, this.age, this.address,  this.description});

  factory Person.fromMap(Map<String, dynamic> json) => Person(
      id: json["id"],
      usuario: json["usuario"],
      rol: json["rol"],
      address: json["address"]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario': usuario,
      'rol': rol,
      'address': address,
    };
  }
}
