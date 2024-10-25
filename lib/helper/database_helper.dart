// services local database
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static DatabaseHelper databaseHelper = DatabaseHelper._();

  Database? _database;
  String databaseName = 'notes.db';
  String tableName = 'notes';

  Future<Database> get database async => _database ?? await initDatabase();

  Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, databaseName);
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        String sql = '''
        CREATE TABLE $tableName (
          id INTEGER NOT NULL,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          date TEXT NOT NULL,
          category TEXT NOT NULL
        )
        ''';
        db.execute(sql);
      },
    );
  }

  Future<bool> noteExists(int id) async {
    final db = await database;
    String sql = '''
    SELECT * FROM $tableName WHERE id = ?
    ''';
    List<Map<String, Object?>> result = await db.rawQuery(sql, [id]);
    return result.isNotEmpty;
  }

  Future<int> addNoteToDatabase(int id, String title, String content,
      String date, String category) async {
    final db = await database;
    String sql = '''
    INSERT INTO $tableName(
    id, title, content, date, category
    ) VALUES (?, ?, ?, ?, ?)
    ''';
    List args = [id, title, content, date, category];
    return await db.rawInsert(sql, args);
  }

  Future<List<Map<String, Object?>>> readAllNotes() async {
    final db = await database;
    String sql = '''
    SELECT * FROM $tableName
    ''';
    return await db.rawQuery(sql);
  }

  Future<Future<List<Map<String, Object?>>>> readNotesByTitle(
      String title) async {
    final db = await database;
    String sql = '''
    SELECT * FROM $tableName WHERE title LIKE '$title%'
    ''';
    return db.rawQuery(sql);
  }

  Future<int> updateNotes(int id, String title, String content, String date,
      String category) async {
    final db = await database;
    String sql = '''
    UPDATE $tableName SET title = ?, content = ?, date = ?, category = ? WHERE id = ?
    ''';
    List args = [title, content, date, category, id];
    return await db.rawUpdate(sql, args);
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    String sql = '''
    DELETE FROM $tableName WHERE id = ?
    ''';
    List args = [id];
    return await db.rawDelete(sql, args);
  }

}
