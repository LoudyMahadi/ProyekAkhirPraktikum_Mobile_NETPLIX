import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/favorite_movie.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'favorites.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY,
            title TEXT,
            posterPath TEXT,
            note TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertFavorite(FavoriteMovie movie) async {
    final db = await database;
    await db.insert('favorites', movie.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<FavoriteMovie>> getFavorites() async {
    final db = await database;
    final maps = await db.query('favorites');

    return List.generate(maps.length, (i) {
      return FavoriteMovie.fromMap(maps[i]);
    });
  }

  Future<void> updateFavorite(FavoriteMovie movie) async {
    final db = await database;
    await db.update(
      'favorites',
      movie.toMap(),
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<void> deleteFavorite(int id) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
