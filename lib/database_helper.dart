import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "ipv4_game.db";
  static const _databaseVersion = 1;

  static const tableUsers = 'users';
  static const columnId = 'id';
  static const columnUsername = 'username';
  static const columnPassword = 'password';

  static const tableScores = 'scores';
  static const columnUserId = 'userId';
  static const columnScore = 'score';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUsers (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUsername TEXT NOT NULL UNIQUE,
        $columnPassword TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE $tableScores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUserId INTEGER,
        $columnScore INTEGER,
        FOREIGN KEY($columnUserId) REFERENCES $tableUsers($columnId)
      );
    ''');
  }

Future<int> insertUser(String username, String password) async {
  if (username.trim().isEmpty || password.trim().isEmpty) return -1;

  final db = await database;
  try {
    return await db.insert(tableUsers, {
      columnUsername: username,
      columnPassword: password,
    });
  } catch (e) {
    return -1; // Usuario duplicado u otro error
  }
}


  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    final db = await database;
    return await db.query(tableUsers);
  }

  Future<void> updateOrInsertScore(int userId, int newScore) async {
    final db = await database;
    final existing = await db.query(tableScores, where: '$columnUserId = ?', whereArgs: [userId]);
    if (existing.isEmpty) {
      await db.insert(tableScores, {columnUserId: userId, columnScore: newScore});
    } else {
      await db.update(tableScores, {columnScore: newScore}, where: '$columnUserId = ?', whereArgs: [userId]);
    }
  }

  Future<List<Map<String, dynamic>>> getTopScores() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT u.$columnUsername AS username, s.$columnScore AS score
      FROM $tableUsers u
      JOIN $tableScores s ON u.$columnId = s.$columnUserId
      ORDER BY s.$columnScore DESC
      LIMIT 5
    ''');
  }
}