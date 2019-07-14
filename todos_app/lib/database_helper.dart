import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todos_app/database_helper2.dart';
import 'package:todos_app/scopedModel.dart';
import 'package:todos_app/todoNotes.dart';

class DatabaseHelper  {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database
  DatabaseHelper2 databaseHelper2 = DatabaseHelper2();

  String noteTable = 'note_table';
  String deletedTable = 'deleted_table';

  String colPriority = 'priority';
  String colNote = 'note';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    // Open/create the database at a given path
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE IF NOT EXISTS $noteTable($colNote TEXT, $colPriority INTEGER)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }


  // Insert Operation: Insert a Note object to database
  Future<int> insertNote(Notes note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }
  Future<int> insertNoteDeleted(Notes note) async {
    databaseHelper2.insertNoteDeleted(note);
//    Database db = await this.database;
//    var result = await db.insert(deletedTable, note.toMap());
    print("note intserted into deleted list");
//    return result;
  }

  // Update Operation: Update a Note object and save it to database


  // Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int priority, String note) async {
    var db = await this.database;
//    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colPriority = $priority and $colNote=$note');
    int result2 = await db.delete(noteTable , where: "note=?",whereArgs: [note]);
    print("deleted = DELETE FROM $noteTable WHERE $colPriority = $priority and $colNote =$note");
    return result2;
  }

  // Get number of Note objects in database


  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Notes>> getNoteList() async {

    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count = noteMapList.length;         // Count the number of map entries in db table

    List<Notes> noteList = List<Notes>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Notes.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }


}