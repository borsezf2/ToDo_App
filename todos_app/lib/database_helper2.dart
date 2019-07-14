import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todos_app/scopedModel.dart';
import 'package:todos_app/todoNotes.dart';

class DatabaseHelper2  {

  static DatabaseHelper2 _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  String deletedTable = 'deleted_table';

  String colPriority = 'priority';
  String colNote = 'note';

  DatabaseHelper2._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper2() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper2._createInstance(); // This is executed only once, singleton object
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
    String path = directory.path + 'Dnotes.db';

    // Open/create the database at a given path
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE IF NOT EXISTS $deletedTable($colNote TEXT, $colPriority INTEGER)');
  }

  // Fetch Operation: Get all note objects from database

  Future<List<Map<String, dynamic>>> getDeletedNoteMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(deletedTable, orderBy: '$colPriority ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database

  Future<int> insertNoteDeleted(Notes note) async {
    Database db = await this.database;
    var result = await db.insert(deletedTable, note.toMap());
    print("note intserted into deleted list");
    return result;
  }

  // Update Operation: Update a Note object and save it to database


  // Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int priority, String note) async {
    var db = await this.database;
//    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colPriority = $priority and $colNote=$note');
    int result2 = await db.delete(deletedTable , where: "note=?",whereArgs: [note]);
    print("deleted = DELETE FROM $deletedTable WHERE $colPriority = $priority and $colNote =$note");
    return result2;
  }
  Future<int> deleteAll() async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $deletedTable ');
//    int result2 = await db.delete(deletedTable , where: "note=?",whereArgs: [note]);
    print("deleted = DELETE FROM $deletedTable ");
    return result;
  }

  // Get number of Note objects in database


  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]

  Future<List<Notes>> getDeletedList() async {

    var deletedNoteMapList = await getDeletedNoteMapList(); // Get 'Map List' from database
    int count = deletedNoteMapList.length;         // Count the number of map entries in db table

    List<Notes> noteList = List<Notes>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Notes.fromMapObject(deletedNoteMapList[i]));
    }
    return noteList;
  }

}