import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  static Database? _database;

  DatabaseManager._internal();

  factory DatabaseManager() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Init
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            text TEXT
          )
        ''');
      },
    );
  }

  // Create note
  Future<int> createNote(String title, String text) async {
    final db = await database;

    // Insert the note into the database
    return await db.insert(
      'notes',
      {'title': title, 'text': text},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all notes
  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query(
      'notes',
      columns: ['id', 'title', 'text'],
    );

    return result;
  }

  Future<Map<String, dynamic>?> getNote(int id) async {
    final db = DatabaseManager();

    final notes = await db.getNotes();

    for (var note in notes) {
      if (id == note['id']) {
        return note;
      }
    }

    return null;
  }

  // Get titles
  Future<List<String>> getTitles() async {
    List<Map<String, dynamic>> notes = await getNotes();
    List<String> result = [];

    for (var note in notes) {
      result.add(note['title']);
    }

    return result;
  }

  // Get texts
  Future<List<String>> getTexts() async {
    List<Map<String, dynamic>> notes = await getNotes();
    List<String> result = [];

    for (var note in notes) {
      result.add(note['text']);
    }

    return result;
  }

  // Change title of the note
  Future<int> changeTitle(int id, String newTitle) async {
    final db = await database;

    return await db.update(
      'notes',
      {'title': newTitle},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Change text of the note
  Future<int> changeText(int id, String newText) async {
    final db = await database;

    return await db.update(
      'notes',
      {'text': newText},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete note by ID
  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all notes
  Future<int> deleteAll() async {
    final db = await database;
    return await db.delete('notes');
  }
}
