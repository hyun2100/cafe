import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:must_eat_place_app/model/cafe.dart';

class DatabaseHandler {
  static final DatabaseHandler _instance = DatabaseHandler._internal();
  factory DatabaseHandler() => _instance;
  static Database? _database;

  DatabaseHandler._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cafe_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cafes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        location TEXT,
        phone TEXT,
        rating TEXT,
        image_data BLOB,
        latitude REAL,
        longitude REAL
      )
    ''');
  }

  Future<int> insertCafe(Cafe cafe) async {
    final db = await database;
    return await db.insert('cafes', cafe.toMap());
  }

  Future<List<Cafe>> getCafes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cafes');
    return List.generate(maps.length, (i) => Cafe.fromMap(maps[i]));
  }

  Future<int> updateCafe(Cafe cafe) async {
    final db = await database;
    return await db.update(
      'cafes',
      cafe.toMap(),
      where: 'id = ?',
      whereArgs: [cafe.id],
    );
  }

  Future<int> deleteCafe(int id) async {
    final db = await database;
    return await db.delete(
      'cafes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
