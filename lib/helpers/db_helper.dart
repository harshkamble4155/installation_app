import 'dart:io';
import 'package:path/path.dart';
import 'package:installation_app/models/db_installation_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final _databaseName = "installation_db.db";
  final _databaseVersion = 1;

  final tbl_installationData = 'tbl_installation';
  final col_id = '_id';
  final col_clientName = 'clientName';
  final col_diameter = 'diameter';
  final col_thickness = 'thickness';
  final col_project = 'project';
  final col_specification = 'specification';
  final col_tpia = 'tpia';
  final col_contractor = 'contractor';
  final col_chainage = 'chainage';
  final col_km = 'km';
  final col_section = 'section';
  final col_location = 'location';
  final col_date = 'date';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tbl_installationData (
          $col_id INTEGER PRIMARY KEY,
          $col_clientName TEXT NOT NULL,
          $col_diameter TEXT NOT NULL,
          $col_thickness TEXT NOT NULL,
          $col_project TEXT NOT NULL,
          $col_specification TEXT NOT NULL,
          $col_tpia TEXT NOT NULL,
          $col_contractor TEXT NOT NULL,
          $col_chainage TEXT NOT NULL,
          $col_km TEXT NOT NULL,
          $col_section TEXT NOT NULL,
          $col_location TEXT NOT NULL,
          $col_date DATETIME
          )
          ''');
  }

  Future<int> insertData(DbInstallationModel dbInstallationModel) async {
    Database db = await instance.database;
    return await db.insert(tbl_installationData, dbInstallationModel.toJson());
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    Database db = await instance.database;
    return await db.query(tbl_installationData);
  }

  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tbl_installationData'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.update(tbl_installationData, row);
  }
}

//   Future close() async => db!.close();
// }
