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

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Membuat Tabel saat Database pertama kali dibuat
  Future _createDB(Database db, int version) async {
    // Tabel Sesi Login (Menyimpan email user yang sedang login)
    await db.execute('''
      CREATE TABLE sesi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL
      )
    ''');

    // Tabel Cache Pagelaran (Menyimpan data pagelaran offline)
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
  }

  // ==========================================
  // FUNGSI UNTUK SESI LOGIN
  // ==========================================

  Future<void> simpanSesi(String email) async {
    final db = await database;
    await db.delete('sesi'); // Hapus sesi lama
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
  // FUNGSI UNTUK CACHE PAGELARAN
  // ==========================================

  Future<void> simpanCachePagelaran(List<Map<String, dynamic>> data) async {
    final db = await database;
    final batch = db.batch();

    // Hapus data lama
    batch.delete('pagelaran_cache');

    // Masukkan data baru
    for (var item in data) {
      batch.insert('pagelaran_cache', {
        'id': item['id'],
        'judul': item['judul'],
        'hari': item['hari'],
        'gambar_url': item['gambar_url'],
        'harga_wni': item['harga_wni'],
        'harga_wna': item['harga_wna'],
      });
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getCachePagelaran() async {
    final db = await database;
    return await db.query('pagelaran_cache');
  }
}
