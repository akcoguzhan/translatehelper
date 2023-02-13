// ignore_for_file: avoid_print, library_private_types_in_public_api, prefer_const_constructors
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:path_provider/path_provider.dart';
import 'package:translatehelper/api/wordapi.dart';
import 'package:translatehelper/entities/word.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const SqliteApp());
}

class SqliteApp extends StatefulWidget {
  const SqliteApp({Key? key}) : super(key: key);

  @override
  _SqliteAppState createState() => _SqliteAppState();
}

class _SqliteAppState extends State<SqliteApp> {
  int? selectedId;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Word Translator',
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: TypeAheadField<Word?>(
                    suggestionsCallback: WordApi.getWordSuggestions,
                    itemBuilder: (context, Word? suggestion) {
                      final word = suggestion!;

                      return ListTile(
                        title: Text(word.name),
                      );
                    },
                    noItemsFoundBuilder: (context) => SizedBox(
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 8,
                            child: Text(
                              'sözcük bulunamadı',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: IconButton(
                              icon: Icon(
                                Icons.add_box_outlined,
                              ),
                              onPressed: () => print('sdfasdf'),
                            ),
                          )
                        ],
                      ),
                    ),
                    onSuggestionSelected: (Word? suggestion) {
                      final word = suggestion!;
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Grocery {
  final int? id;
  final String name;

  Grocery({this.id, required this.name});

  factory Grocery.fromMap(Map<String, dynamic> json) => Grocery(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'groceries.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE groceries(
id INTEGER PRIMARY KEY,
name TEXT
)
''');
  }

  Future<List<Grocery>> getGroceries() async {
    Database db = await instance.database;
    var groceries = await db.query('groceries', orderBy: 'name');
    List<Grocery> groceryList = groceries.isNotEmpty ? groceries.map((c) => Grocery.fromMap(c)).toList() : [];
    return groceryList;
  }

  Future<int> add(Grocery grocery) async {
    Database db = await instance.database;
    return await db.insert('groceries', grocery.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('groceries', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Grocery grocery) async {
    Database db = await instance.database;
    return await db.update('groceries', grocery.toMap(), where: "id = ?", whereArgs: [grocery.id]);
  }
}
