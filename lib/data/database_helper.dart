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
      version: 4, // NAIKKAN LAGI KE VERSI 4
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Kita buat logikanya lebih luas:
    // "Jika versi lama di bawah 4, pastikan kolom ini ada"
    if (oldVersion < 4) {
      try {
        await db.execute('''
          ALTER TABLE history ADD COLUMN bounding_boxes TEXT
        ''');
      } catch (e) {
        // Jika kolom ternyata sudah ada, catch ini akan mencegah aplikasi crash
        print("Kolom mungkin sudah ada: $e");
      }
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        image_path TEXT NOT NULL,
        detected_class TEXT NOT NULL,
        confidence_score TEXT NOT NULL,
        detected_at TEXT NOT NULL,
        bounding_boxes TEXT
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

  // hapus semua data
  Future<int> deleteAllHistory() async {
    final db = await instance.database;
    return await db.delete('history');
  }
}
