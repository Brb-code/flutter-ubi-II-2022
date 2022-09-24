import 'package:flutter_sqlite_crud/Tareas.dart';
import 'package:flutter_sqlite_crud/student_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'tareas2.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute('CREATE TABLE tareas (id INTEGER PRIMARY KEY, name TEXT, descripcion TEXT)');
  }

  Future<Tareas> add(Tareas tr) async {
    var dbClient = await db;
    tr.id = await dbClient.insert('tareas', tr.toMap());
    return tr;
  }

  Future<List<Tareas>> getTareas() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('tareas', columns: ['id', 'name', 'descripcion']);
    List<Tareas> tr = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        tr.add(Tareas.fromMap(maps[i]));
      }
    }
    return tr;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'tareas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Tareas tr) async {
    var dbClient = await db;
    return await dbClient.update(
      'tareas',
      tr.toMap(),
      where: 'id = ?',
      whereArgs: [tr.id],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
