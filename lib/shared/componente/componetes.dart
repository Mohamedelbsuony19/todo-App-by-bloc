import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:new_todo_app/shared/cubit/cubit.dart';

Widget defaultFromFaild({
  required TextEditingController controller,
  required TextInputType type,
  dynamic onSubmit,
  dynamic onChange,
  dynamic ontab,
  bool isPasword = false,
  required dynamic validate,
  required String lable,
  required IconData prefix,
  IconData? suffix,
  dynamic sufixpressed,
}) =>
    TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: isPasword,
        onFieldSubmitted: onSubmit,
        onChanged: onChange,
        onTap: ontab,
        validator: validate,
        decoration: InputDecoration(
          labelText: lable,
          prefixIcon: Icon(prefix),
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: sufixpressed,
                  icon: Icon(
                    suffix,
                  ),
                )
              : null,
          border: OutlineInputBorder(),
        ));

Widget buildTaskItem(Map model, context) => Dismissible(
      key:Key(model['id'].toString(),) ,
      onDismissed: (direction){
        appCubit.get(context).Delete(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                '${model['time']}',
                style: TextStyle(),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  appCubit.get(context).upDate(des: 'done', id: model['id']);
                },
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  appCubit.get(context).upDate(des: 'archive', id: model['id']);
                },
                icon: Icon(
                  Icons.archive,
                  color: Colors.black45,
                )),
          ],
        ),
      ),
    );

Widget TaskedBuild(List tasks)=>ConditionalBuilder(
    condition: tasks.length>0,
    builder: (context)=>ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
        separatorBuilder: (context, index) =>
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
        itemCount:tasks.length),
    fallback: (context)=> Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu,size: 100,color: Colors.grey,),
          Text('No tasked..Can You Add Your Tasks Now',
            style: TextStyle(
                fontSize: 18,
                color: Colors.grey
            ),
          )
        ],
      ),
    ));
