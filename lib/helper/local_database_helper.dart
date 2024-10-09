import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();
  static Database? _database;

  LocalDatabase._internal();

  factory LocalDatabase() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cart_database.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE cart(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            product TEXT,
            category TEXT,
            price TEXT
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<void> addToCart(String product, String category) async {
    final db = await database;
    await db.insert(
      'cart',
      {
        'product': product,
        'category': category,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await database;
    return await db.query('cart');
  }

  Future<void> updateCartItem(int id, String product, String category) async {
    final db = await database;
    await db.update(
      'cart',
      {
        'product': product,
        'category': category,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteCartItem(int id) async {
    final db = await database;
    await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
