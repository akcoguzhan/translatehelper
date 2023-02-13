import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:translatehelper/entities/word.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'words.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE words(
      id INTEGER PRIMARY KEY,
      name TEXT
    )
    ''');
  }

  Future<List<Word>> getWords() async {
    Database db = await instance.database;
    var words = await db.query('words', orderBy: 'name');
    List<Word> wordList = words.isNotEmpty ? words.map((e) => Word.fromMap(e)).toList() : [];

    return wordList;
  }

  Future<int> add(Word word) async {
    Database db = await instance.database;
    return await db.insert('words', word.toMap());
  }
}
