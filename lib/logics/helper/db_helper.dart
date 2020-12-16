import 'dart:io';

import '../model/file_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper db = DBHelper._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Files.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE file (id INTEGER PRIMARY KEY, fileName TEXT, fileUrl TEXT)');
    });
  }

  insertData(FileModel fileModel) async {
    final db = await database;
    var res = await db.insert("file", fileModel.toJson());
    print('insert $res');
    return res;
  }

  Future<List<FileModel>> getAllFiles() async {
    final db = await database;
    var res = await db.query("file");
    List<FileModel> list =
        res.isNotEmpty ? res.map((c) => FileModel.fromMap(c)).toList() : [];
    print('list ${list.toString()}');
    return list;
  }

  deletefile(int id) async {
    final db = await database;
    db.delete("file", where: "id = ?", whereArgs: [id]);
  }
}
