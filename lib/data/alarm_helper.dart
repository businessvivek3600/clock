import 'package:sqflite/sqflite.dart';

import '../models/alarm_model.dart';

const String tableAlarm = 'alarms';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnDescription = 'description';
const String columnDateTime = 'time';
const String columnPending = 'isPending';
const String isOn = 'isOn';
const String color1 = 'color1';
const String color2 = 'color2';

class AlarmHelper {
  static Database? _database;
  static AlarmHelper? _alarmHelper;

  AlarmHelper._createInstance();
  factory AlarmHelper() {
    _alarmHelper ??= AlarmHelper._createInstance();
    return _alarmHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = "${dir}alarms.db";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) => createAlarmTable(db),
    );
    return database;
  }

  Future<void> createAlarmTable(Database db) async {
    await db.execute('''
  create table $tableAlarm (
    $columnId integer primary key autoincrement,
    $columnTitle text not null,
    $columnDescription text,
    $columnDateTime text not null,
    $columnPending integer,
    $isOn int,
    $color1 integer,
    $color2 integer)
''');
  }

  void insertAlarm(Alarm alarm) async {
    var db = await database;
    print('alarm : ${alarm.toJson()} ${await db.getVersion()}');
    // await createAlarmTable(db);
    var result = await db.insert(tableAlarm, alarm.toJson());
    print('result : $result');
  }

  Future<List<Alarm>> getAlarms() async {
    List<Alarm> _alarms = [];

    var db = await database;
    var result = await db.query(tableAlarm);
    for (var element in result) {
      var alarm = Alarm.fromJson(element);
      _alarms.add(alarm);
    }

    return _alarms;
  }

  Future<int> delete(int? id) async {
    var db = await database;
    return await db.delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
  }

  ///drop table
  Future<int> deleteTable() async {
    var db = await database;
    return await db.delete(tableAlarm);
  }
}
