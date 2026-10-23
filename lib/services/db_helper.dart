import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('srimanganti.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Versi 4: Paksa hapus database lama agar bersih total
    return await openDatabase(
      path,
      version: 4, 
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS users');
        await db.execute('DROP TABLE IF EXISTS sesi');
        await db.execute('DROP TABLE IF EXISTS pagelaran_cache');
        await _createDB(db, newVersion);
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sesi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE pagelaran_cache (
        id TEXT PRIMARY KEY,
        judul TEXT,
        hari TEXT,
        gambar_url TEXT,
        harga_wni INTEGER,
        harga_wna INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT,
        nama_lengkap TEXT,
        no_whatsapp TEXT
      )
    ''');
  }

  // ==========================================
  // FUNGSI SESI
  // ==========================================
  Future<void> simpanSesi(String email) async {
    final db = await database;
    await db.delete('sesi');
    await db.insert('sesi', {'email': email});
  }

  Future<String?> getSesi() async {
    final db = await database;
    final result = await db.query('sesi', limit: 1);
    if (result.isNotEmpty) {
      return result.first['email'] as String;
    }
    return null;
  }

  Future<void> hapusSesi() async {
    final db = await database;
    await db.delete('sesi');
  }

  // ==========================================
  // FUNGSI USER
  // ==========================================
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}