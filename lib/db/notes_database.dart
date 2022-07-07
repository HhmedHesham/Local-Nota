import 'package:sqflite/sqflite.dart';

import '../models/note_model.dart';

class NotesDatabase {
  // singleton instance of the database "which is global to the app"
  static final NotesDatabase _instance = NotesDatabase._init();

  //create field for database
  static Database? _database;

  // initialize the database
  NotesDatabase._init();

  //open database
  Future<Database> get database async {
    // if exists, return the database
    if (_database != null) {
      return _database!;
    }
    // if not initialize it
    _database = await _initDB(filePath: 'notes.db');
    return _database!;
  }

  // initialize the database
  Future<Database> _initDB({required String filePath}) async {
    // get the default path to the database
    final String path = await getDatabasesPath();
    final String dbPath = '$path/notes.db';
    // if u change the version of the database, it will trigger onupgrade method
    // create db if not exists
    final Database database =
        await openDatabase(dbPath, version: 1, onCreate: _createDB);
    return database;
  }

  // create the database schema
  void _createDB(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE $tableNotes (
      ${NoteFields.id} INTEGER PRIMARY KEY AUTOINCREMENT, 
      ${NoteFields.number} INTEGER, 
      ${NoteFields.isImportnant} BOOLEAN NOT NULL, 
      ${NoteFields.title} TEXT NOT NULL, 
      ${NoteFields.description} TEXT NOT NULL, 
      ${NoteFields.date} TEXT NOT NULL
      )''',
    );
  }

  // close the database
  Future<void> close() async {
    final db = await _instance.database;
    db.close();
  }
}