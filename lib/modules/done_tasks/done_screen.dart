import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_todo_app/shared/componente/componetes.dart';
import 'package:new_todo_app/shared/componente/constans.dart';
import 'package:new_todo_app/shared/cubit/cubit.dart';
import 'package:new_todo_app/shared/cubit/states.dart';


class doneScreen extends StatelessWidget {
  const doneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    appCubit cubit = appCubit.get(context);

    return BlocConsumer<appCubit, appStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return TaskedBuild(cubit.donetasks);
      },
    );
  }
}
