import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_todo_app/modules/archive_tasks/archive_screen.dart';
import 'package:new_todo_app/modules/done_tasks/done_screen.dart';
import 'package:new_todo_app/shared/componente/componetes.dart';
import 'package:sqflite/sqflite.dart';
import '../modules/new_tasks/new_tasks_screen.dart';
import 'package:intl/intl.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import '../shared/componente/constans.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class homeLayote extends StatelessWidget {
  var scafoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  var titleControlar = TextEditingController();
  var timeControlar = TextEditingController();
  var dateControlar = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => appCubit()..createdataBase(),
      child: BlocConsumer<appCubit, appStates>(
        listener: (context, state) {
          if(state is appInsertDataBase){
            Navigator.pop(context);
            // appCubit.get(context).isBottomsheetShow=false;
            // appCubit.get(context).myIcone=Icons.edit;
          }
        },
        builder: (context, state) {
          appCubit cubit=appCubit.get(context);
          return Scaffold(
            key: scafoldKey,
            appBar: AppBar(
              title: Text(appCubit.get(context).titls[cubit.current]),
              centerTitle: true,
            ),
            body:
            ConditionalBuilder(
              condition: true,
              builder: (context) => cubit.screens[cubit.current],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomsheetShow) {
                  cubit.insertDataBase(title: titleControlar.text,
                      time: timeControlar.text,
                      date: dateControlar.text);
                  // if (formKey.currentState!.validate()) {
                  //   insertDataBase(
                  //       date: dateControlar.text,
                  //       time: timeControlar.text,
                  //       title: titleControlar.text)
                  //       .then((value) {
                  //     Navigator.pop(context);
                  //     cubit.changeBottomSheetState(isShow: false,
                  //         icon: Icons.edit);
                  //     // isBottomsheetShow = false;
                  //     // setState(() {
                  //     //   myIcone = Icons.edit;
                  //     // });
                  //   });
          } else {
                  scafoldKey.currentState!.showBottomSheet((context) =>
                      Container(
                        color: Colors.grey[100],
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFromFaild(
                                  controller: titleControlar,
                                  type: TextInputType.text,
                                  validate: (value) {
                                    if (value.isEmpty) {
                                      return ('title is empty');
                                    }
                                  },
                                  lable: 'Task Title',
                                  prefix: Icons.title),
                              SizedBox(
                                height: 15,
                              ),
                              defaultFromFaild(
                                  ontab: () {
                                    showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeControlar.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  controller: timeControlar,
                                  type: TextInputType.datetime,
                                  validate: (value) {
                                    if (value.isEmpty) {
                                      return ('time is empty');
                                    }
                                  },
                                  lable: 'Time',
                                  prefix: Icons.watch_later_outlined),
                              SizedBox(
                                height: 15,
                              ),
                              defaultFromFaild(
                                  ontab: () {
                                    showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('3030-01-22'))
                                        .then((value) {
                                      dateControlar.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  controller: dateControlar,
                                  type: TextInputType.datetime,
                                  validate: (value) {
                                    if (value.isEmpty) {
                                      return ('date is empty');
                                    }
                                  },
                                  lable: 'Date',
                                  prefix: Icons.calendar_month_outlined),
                            ],
                          ),
                        ),
                      )
                  ).closed.then((value){
                    cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true,
                      icon: Icons.add);
                  // setState(() {
                  //   myIcone = Icons.add;
                  // });
                }
              },
              child: Icon(cubit.myIcone),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: appCubit.get(context).current,
              onTap: (index) {
                // setState(() {
                //   current = index;
                // });
                appCubit.get(context).changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived'),
              ],
            ),
          );
        },
      ),
    );
  }

}

