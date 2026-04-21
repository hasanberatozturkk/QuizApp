import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category.dart';
import '../models/questions.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase('quiz.db');
    return _database!;
  }

  Future<Database> _initDatabase(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // burası veritabanı oluşturulurken kullanılır.
  Future<void> _createDB(Database db, int version) async {
    await db.execute(''' 
    CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL )
    ''');
    await db.execute('''
    CREATE TABLE questions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      categoryId INTEGER NOT NULL,
      question TEXT NOT NULL,
      correctAnswer TEXT NOT NULL,
      options TEXT NOT NULL,
      FOREIGN KEY (categoryId) REFERENCES categories(id) )
    ''');
  }

  // yeni kategori ekleme
  Future<void> insertCategory(Category category) async {
    final db = await instance.database;
    await db.insert('categories', category.toMap());
  }

  // yeni soru ekleme
  Future<void> insertQuestion(Question question) async {
    final db = await instance.database;
    await db.insert('questions', question.toMap());
  }

  // kategori listeleme
  Future<List<Category>> getCategories() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(
      maps.length,
      (i) => Category.fromMap(maps[i]),
    ).toList();
  }

  // belirli bir kategoriye ait soruları listeleme
  Future<List<Question>> getQuestionsByCategory(
    int categoryId, {
    int limit = 12,
  }) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      '''
      SELECT * FROM questions
      WHERE categoryId = ?
      ORDER BY RANDOM()
      LIMIT ?
      ''',
      [categoryId, limit],
    ); //
    return result.map((map) => Question.fromMap(map)).toList();
  }
}
