import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_todo_app/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/archive_tasks/archive_screen.dart';
import '../../modules/done_tasks/done_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';
import '../componente/constans.dart';

class appCubit extends Cubit<appStates>{
  appCubit():super(initState());
  static appCubit get(context)=>BlocProvider.of(context);

  late int current = 0;
  late List<Widget> screens = [newTasksScreen(), doneScreen(), archiveScreen()];
  late List<String> titls = ['New Tasks', 'Done Tasks', 'Archive Tasks'];
  late Database dataBase;
  late List<Map<dynamic,dynamic>>Newtasks=[];
  late List<Map<dynamic,dynamic>>donetasks=[];
  late List<Map<dynamic,dynamic>>archivetasks=[];
  late bool isBottomsheetShow = false;
  late IconData myIcone = Icons.edit;


  void changeIndex(int index){
    current=index;
    emit(changeNavBarState());
  }


  void createdataBase()  {
    openDatabase('todo.db', version: 1,
        onCreate: (dataBase, version) {
          dataBase
              .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT ,date TEXT, time TEXT, des TEXT)')
              .then((value) {
            print('table is created');
          }).catchError((e) {
            print('error in table created ${e.toString()}');
          });
          print('data base is cearted');
        }, onOpen: (dataBase) {
          getDataBase(dataBase);
          print('opened is data base');
        }).then((value){
          dataBase=value;
          emit(appCreateDataBase());
    });
  }

   insertDataBase({
    required String title,
    required String time,
    required String date,
  }) async {
     await dataBase.transaction((txn) async {
      await txn
          .rawInsert(
          'INSERT INTO tasks(title, date, time, des) VALUES("$title", "$date", "$time","new")',
      )
          .then((value) {
        print('$value inserted successfully');
        emit(appInsertDataBase());
        getDataBase(dataBase);
      }).catchError((e) {
        print('error in inserted ${e.toString()}');
        return;
      });
    });
  }

  void getDataBase(dataBase)  {
    Newtasks=[];
    donetasks=[];
    archivetasks=[];
    emit(appGetDataBase());
    dataBase.rawQuery('SELECT * FROM tasks').then((value) {
      // tasks = value;
      // print(tasks);
      emit(appGetDataBase());
      value.forEach((element) {
            if(element['des']=='new'){
              Newtasks.add(element);
            }else if(element['des']=='done'){
              donetasks.add(element);
            }else{
              archivetasks.add(element);
            }
      });
    });

  }

  void upDate({
  required String des,
  required int id,
})async {
    dataBase.rawUpdate(
      'UPDATE tasks SET des = ? WHERE id = ?',
      ['$des', id],).then((value) {
      getDataBase(dataBase);
      emit(upDateDataBase());
      // print(tasks);
    });
    }

    void changeBottomSheetState({required bool isShow, required IconData icon
    }) {
      isBottomsheetShow = isShow;
      myIcone = icon;
      emit(chngeBtnSheetState());
    }
  void Delete({
    required int id,
  }) async {
    dataBase.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value) {
      getDataBase(dataBase);
      emit(deletDataBaseStatus());
      // print(tasks);
    });
  }
}
