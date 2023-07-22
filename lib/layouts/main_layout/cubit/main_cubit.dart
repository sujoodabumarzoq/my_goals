import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_goals/layouts/main_layout/cubit/main_states.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(InitState());

  static MainCubit get(context) => BlocProvider.of(context);

  var addTextController = TextEditingController();
  var editTextController = TextEditingController();

  initSql() async {
    //1
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'goals.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute('''CREATE TABLE Goals 
              (id INTEGER PRIMARY KEY,
               name TEXT)''');
        });
  }

  List<Map> goalsList = [];

  getData() async {
    //1*
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'goals.db');
    Database database = await openDatabase(path);

    //then اذا نجحت
    // اذا لا اعمل catchError
    await database.rawQuery('SELECT * FROM Goals').then((value) {
      goalsList = value;
      emit(GetDataSuccessState());
    }).catchError((onError) {
      emit(GetDataErrorState());
      print(onError.toString());
    });

    database.close();
  }

  updata(int id, String name) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'goals.db');
    Database database = await openDatabase(path);
    await database.rawUpdate('UPDATE Goals SET name = ? WHERE id = ?', [name, id])
        .then((value) {
      emit(UpdateDataSuccessState());
    }).catchError((onError) {
      emit(UpdateDataErrorState());
      print(onError.toString());
    });

    database.close();
  }

  insertData(String name) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'goals.db');
    Database database = await openDatabase(path);

    await database.rawInsert('INSERT INTO Goals(name) VALUES(?)', [name])
        .then((value) {
      emit(InsertDataSuccessState());
    }).catchError((onError) {
      emit(InsertDataErrorState());
      print(onError.toString());
    });

    database.close();
  }

  removeData(id) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'goals.db');
    Database database = await openDatabase(path);

    await database.rawDelete('DELETE FROM Goals WHERE id = ?', [id])
        .then((value) {
      emit(RemoveDataSuccessState());
    }).catchError((onError) {
      emit(RemoveDataErrorState());
      print(onError.toString());
    });

    database.close();
  }
}
