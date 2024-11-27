import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model/Persons.dart';

class SQLHelper {
  static Database? _database;

  // Método para inicializar la base de datos
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Configuración inicial de la base de datos
  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'persondetails.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE persondetails (
            id TEXT PRIMARY KEY,
            usuario TEXT,
            rol TEXT,
            address TEXT
          )
        ''');
      },
    );
  }

  // Insertar un nuevo registro
  static Future<int> insert(Person person) async {
    final db = await SQLHelper.database;

    return await db.insert(
      'persondetails',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los registros
  static Future<List<Person>> getAllPersons() async {
    final db = await SQLHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('persondetails');

    return List.generate(maps.length, (i) {
      return Person(
        id: maps[i]['id'],
        usuario: maps[i]['usuario'],
        rol: maps[i]['rol'],
        address: maps[i]['address'],
      );
    });
  }

  // Actualizar un registro
  static Future<int> update(
      String id, String usuario, String rol, String address) async {
    final db = await SQLHelper.database;

    return await db.update(
      'persondetails',
      {'usuario': usuario, 'rol': rol, 'address': address},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Eliminar un registro
  static Future<void> deletePerson(String id) async {
    final db = await SQLHelper.database;
    await db.delete(
      'persondetails',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
