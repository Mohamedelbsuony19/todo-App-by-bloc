import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:new_todo_app/shared/bloc_opserver.dart';

import 'layout/home_layout.dart';

void main(){
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: homeLayote(),
    );
  }
}
