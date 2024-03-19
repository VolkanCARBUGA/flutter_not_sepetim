// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_not_sepetim/model/category.dart';
import 'package:flutter_not_sepetim/model/notes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper!;
    } else {
      return _databaseHelper!;
    }
  }
  Future<Database?> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "notes.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      debugPrint("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "notes.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      debugPrint("Opening existing database");
    }
// open the database
    return await openDatabase(path, readOnly: false);
  }

  Future<List<Category>> getCategory() async {
    var db = await _getDatabase();
    var result = await db!.query('categories');
    return result.map((e) => Category.fromMap( e)).toList();
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    var db = await _getDatabase();
    var result = await db!.rawQuery(
        'select * from notes inner join categories on notes.categoryId=categories.categoryId order by noteCreatedTime desc');
    return result;
  }

  Future<List<Notes>> getNotesList() async {
    var categoryMapList = await getNotes();
    var categoryList = <Notes>[];
    for (var category in categoryMapList) {
      categoryList.add(Notes.fromMap(category));
    }
    return categoryList;
  }

  Future<int> insertCategory(Category category) async {
    var db = await _getDatabase();
    var result = await db!.insert('categories', category.toMap());
    return result;
  }

  Future<int> insertNote(Notes notes) async {
    var db = await _getDatabase();
    var result = await db!.insert('notes', notes.toMap());
    return result;
  }

  Future<int> deleteCategory(int categoryId) async {
    var db = await _getDatabase();
    var result = await db!
        .delete('categories', where: 'categoryId=?', whereArgs: [categoryId]);
    return result;
  }

  Future<int> deleteNote(int noteId) async {
    var db = await _getDatabase();
    var result =
        await db!.delete('notes', where: 'noteId=?', whereArgs: [noteId]);
    return result;
  }

  Future<int> updateCategory(Category category) async {
    var db = await _getDatabase();
    var result = await db!.update('categories', category.toMap(),
        where: 'categoryId=?', whereArgs: [category.categoryId]);
    return result;
  }

  Future<int> updateNote(Notes notes) async {
    var db = await _getDatabase();
    var result = await db!.update('notes', notes.toMap(),
        where: 'noteId=?', whereArgs: [notes.noteId]);
    return result;
  }

  Future close() async {
    var db = await _getDatabase();
    db!.close();
  }

  Future<bool> isCategoryExists(String categoryName) async {
    var db = await _getDatabase();
    var result = await db!.query('categories',
        where: 'categoryName = ?', whereArgs: [categoryName]);
    return result.isNotEmpty;
  }

  String dateFormat(DateTime dateTime) {
    DateTime today = DateTime.now();
    Duration oneDay = const Duration(days: 1);
    Duration twoDay = const Duration(days: 2);
    Duration oneWeek = const Duration(days: 7);
    String? month;
    switch (dateTime.month) {
      case 1:
        month = "Ocak";
        break;
      case 2:
        month = "Subat";
        break;
      case 3:
        month = "Mart";
        break;
      case 4:
        month = "Nisan";
        break;
      case 5:
        month = "Mayis";
        break;
      case 6:
        month = "Haziran";
        break;
      case 7:
        month = "Temmuz";
        break;
      case 8:
        month = "Agustos";
        break;
      case 9:
        month = "Eylul";
        break;
      case 10:
        month = "Ekim";
        break;
      case 11:
        month = "Kasim";
        break;
      case 12:
        month = "Aralik";
        break;
    }
    Duration difference = today.difference(dateTime);

    if (difference.compareTo(oneDay) < 1) {
      return "Bugün";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Dün";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (dateTime.weekday) {
        case 1:
          return "Pazartesi";
        case 2:
          return "Sali";
        case 3:
          return "Carsamba";
        case 4:
          return "Persembe";
        case 5:
          return "Cuma";
        case 6:
          return "Cumartesi";
        case 7:
          return "Pazar";
      }
    } else if (dateTime.year == today.year) {
      return "${dateTime.day} $month ";
    } else {
      return "${dateTime.day} $month ${dateTime.year}";
    }
    return "";
  }
}
