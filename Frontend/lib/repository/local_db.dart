import 'dart:io';

import 'package:lastlearn/models/user.dart';
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import 'package:lastlearn/models/progress.dart';
import 'package:lastlearn/models/vocabulary.dart';
import '../models/word_of_day.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper.internal();
  DBHelper.internal();
  factory DBHelper() => _instance;

  Database? _db;
  final int version = 1;

  Future<Database> openDb() async {
    if (_db != null) return _db!;
    _db = await openDatabase(
      join(await getDatabasesPath(), "localafaanoromoodata.db"),
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE Progress(userId TEXT PRIMARY KEY,alphabet INTEGER, sound INTEGER,word INTEGER, sentence INTEGER,paragraph INTEGER)");
        db.execute(
            "CREATE TABLE Vocabularies(id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT, category TEXT, meaning TEXT, description TEXT)");
        db.execute(
            "CREATE TABLE WordOfTD(id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT, category TEXT, meaning TEXT, example TEXT)");
        db.execute(
            "CREATE TABLE User(_id TEXT PRIMARY KEY,email TEXT, password TEXT,firstName TEXT, lastName TEXT,role TEXT)");
      },
      version: version,
    );
    return _db!;
  }

  Future<int> insertWordOfDay(WordofDay word) async {
    int id = 0;
    try {
      _db = await openDb();
      id = await _db!.insert(
        "WordOfTD",
        word.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
    }
    return id;
  }

  Future<int> insertUser(User user) async {
    int id = 0;
    try {
      _db = await openDb();
      id = await _db!.insert(
        "User",
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
    }
    return id;
  }

  Future<User?> getUser() async {
    User user;
    try {
      _db = await openDb();
      List<Map<String, dynamic>> maps = await _db!.query("User");
      print(maps[0]);
      user = User.fromJson(maps[0]);
      print(user);
      return user;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<int> insertProgress(Progress progress) async {
    int id = 0;
    try {
      _db = await openDb();
      id = await _db!.insert(
        "Progress",
        progress.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
    }
    return id;
  }

  Future<Progress?> loadProgress(String id) async {
    Progress progress;
    try {
      _db = await openDb();
      List<Map<String, dynamic>> maps = await _db!.query(
        "Progress",
        where: "userId = ?",
        whereArgs: [id],
      );
      print(maps[0]);
      progress = Progress.fromMap(maps[0]);
      print("--------------------------$progress");
      return progress;
    } catch (e) {
      return null;
    }
  }

  Future<Progress?> updateProgress(
      String specific, int value, String userId) async {
    Progress? progress;
    int specificValue = value >= 100 ? 100 : value;
    try {
      _db = await openDb();
      int updated = await _db!.update(
        "Progress",
        where: "userId = ?",
        whereArgs: [userId],
        {specific: specificValue},
      );
      progress = await loadProgress(userId);
      return progress;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<int> insertProgressLocal(Progress progress) async {
    int id = 0;
    try {
      _db = await openDb();
      id = await _db!.insert(
        "SaveProgressLocal",
        progress.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
    }
    return id;
  }

  Future<List<Vocabulary>> insertVocabulary(Vocabulary vocab) async {
    List<Vocabulary> vocabs = [];
    try {
      _db = await openDb();
      await _db!.insert(
        "Vocabularies",
        vocab.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      vocabs = await loadVocabularies();
      return vocabs;
    } catch (e) {
      print(e);
      return vocabs;
    }
  }

  Future<List<Vocabulary>> loadVocabularies() async {
    List<Vocabulary> word = [];
    try {
      _db = await openDb();
      List<Map<String, dynamic>> maps = await _db!.query("Vocabularies");

      word = maps.map((e) => Vocabulary.fromJson(e)).toList();

      return word;
    } catch (e) {
      print(e);
      return word;
    }
  }

  Future<bool> updateVocabulary(
      Vocabulary unedited, Vocabulary vocabulary) async {
    int id = 0;
    try {
      _db = await openDb();
      id = await _db!.update(
        "Vocabularies",
        vocabulary.toMap(),
        where: "id = ?",
        whereArgs: [unedited.localId],
      );
      print("updated or $id");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteVocabulary(int id) async {
    int result = 0;
    try {
      _db = await openDb();
      result = await _db!.delete(
        "Vocabularies",
        where: "id = ?",
        whereArgs: [id],
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<int> deleteWordOfDay(WordofDay word) async {
    int result = 0;
    try {
      _db = await openDb();
      result = await _db!.delete(
        "WordOfTD",
        where: "id = ?",
        whereArgs: [word.localId],
      );
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<List<WordofDay>> shareTodaysWord(WordofDay word) async {
    try {
      _db = await openDb();
      await _db!.insert(
        "WordOfTD",
        word.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      List<WordofDay> wordofDay = await loadTodaysWord();

      return wordofDay;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<WordofDay>> loadTodaysWord() async {
    List<WordofDay> word = [];
    try {
      _db = await openDb();
      List<Map<String, dynamic>> maps = await _db!.query("WordOfTD");

      word = maps.map((e) => WordofDay.fromJson(e)).toList();
      print("these words--------------------------- $word");
      return word;
    } catch (e) {
      print(e);
      return word;
    }
  }

  Future<bool> editMyWord(WordofDay unedited, WordofDay word) async {
    try {
      int id = 0;
      _db = await openDb();

      id = await _db!.update(
        "WordOfTD",
        word.toMap(),
        where: "id = ?",
        whereArgs: [unedited.localId],
      );
      if (id == 1) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteMyWord(WordofDay word) async {
    int result = 0;
    try {
      _db = await openDb();
      result = await _db!.delete(
        "WordOfTD",
        where: "id = ?",
        whereArgs: [word.localId],
      );
      if (result == 1) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<void> logout() async {
    // Close the database connection if it's open
    //
    if (_db!.isOpen) {
      await _db!.close();
    }
    // Delete the database file
    await deleteDatabase(await getDatabasesPath());
  }

  Future<void> deletMe() async {
    // Close the database connection if it's open
    //
    if (_db!.isOpen) {
      await _db!.close();
    }
    // Delete the database file
    await deleteDatabase(await getDatabasesPath());
  }
}
