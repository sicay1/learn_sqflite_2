import 'dart:io';

import 'package:learn_sqflite_2/models/employee_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Employee table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'employee_manager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Employee('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'email TEXT,'
          'firstName TEXT,'
          'lastName TEXT,'
          'avatar TEXT'
          ')');
    });
  }

  createEmployee(Employee em) async {
    // await deleteAllEmployee();

    final db = await database;
    final res = await db.insert('Employee', em.toJson());

    return res;
  }

  deleteAllEmployee() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Employee');
    return res;
  }

  Future<List<Employee>> getAllEmployees() async {
    final db = await database;
    final res = await db.rawQuery('SELECT * FROM Employee');

    List<Employee> li =
        res.isNotEmpty ? res.map((e) => Employee.fromJson(e)).toList() : [];

    return li;
  }

  deleteEmployeeById(int idx) async {
    final db = await database;
    final res = await db.delete('Employee', where: 'id = ?', whereArgs: [idx]);
    return res;
  }
}
