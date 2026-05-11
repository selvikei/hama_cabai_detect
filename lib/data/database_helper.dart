import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/history_mode.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pest_history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        image_path TEXT NOT NULL,
        detected_class TEXT NOT NULL,
        confidence_score TEXT NOT NULL,
        detected_at TEXT NOT NULL
      )
    ''');
  }

  // Simpan data
  Future<int> insertHistory(HistoryModel history) async {
    final db = await instance.database;
    return await db.insert('history', history.toMap());
  }

  // Ambil semua data (diurutkan dari yang terbaru)
  Future<List<HistoryModel>> getAllHistory() async {
    final db = await instance.database;
    final result = await db.query('history', orderBy: 'ID DESC');
    return result.map((json) => HistoryModel.fromMap(json)).toList();
  }

  // Hapus satu data
  Future<int> deleteHistory(int id) async {
    final db = await instance.database;
    return await db.delete('history', where: 'ID = ?', whereArgs: [id]);
  }
}