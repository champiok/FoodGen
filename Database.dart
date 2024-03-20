import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart'; // Correct the path based on your project structure

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
  
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'fg.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            user_id INTEGER PRIMARY KEY AUTOINCREMENT,
            first_name TEXT NOT NULL,
            last_name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          )
        ''');
      },
      version: 1,
    );
  }

  Future<int> newUser(User newUser) async {
    final db = await database;

    var res = await db.insert(
      'users',
      newUser.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return res;
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    var res = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return res.isNotEmpty ? User.fromMap(res.first) : null;
  }
}
