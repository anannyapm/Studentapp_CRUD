import 'dart:io';

import 'package:flutter/material.dart';

import 'package:studentrepo_sqflite/functions/db_functions.dart';
import 'package:studentrepo_sqflite/model/model.dart';
import 'package:studentrepo_sqflite/screens/screenprofile.dart';

class ListDataWidget extends StatefulWidget {
  const ListDataWidget({super.key});

  @override
  State<ListDataWidget> createState() => _ListDataWidgetState();
}

class _ListDataWidgetState extends State<ListDataWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: studentListNotifier,
      builder:
          (BuildContext ctx, List<StudentModel> studentList, Widget? child) {
        return ListView.separated(
          itemBuilder: (ctx, indexVal) {
            //studentdata used to fetch each student's data from student list one by one
            final studentdata = studentList[indexVal];
            return InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (ctx1) {
                  return ScreenProfile(
                    firstname: studentdata.firstname,
                    lastname: studentdata.lastname,
                    age: studentdata.age,
                    major: studentdata.major,
                    photo: studentdata.photo,
                    index: indexVal,
                  );
                }));
              },
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: FileImage(File(studentdata.photo)),
                ),
                title: Text(
                  "${studentdata.firstname} ${studentdata.lastname}",
                ),
                trailing: IconButton(
                  onPressed: () {
                    if (indexVal != null) {
                      popDialogueBox(indexVal);
                      //deleteStudent(indexVal);
                      print('Deleted value from $indexVal');
                    } else
                      print('ID passed is null');
                  },
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete profile',
                  color: Colors.red,
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: studentList.length,
        );
      },
    );
  }

  popDialogueBox(int indexValue) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Do you want to delete this entry?"),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
            actionsOverflowButtonSpacing: 20,
            actions: [
              ElevatedButton(
                  onPressed: () {
                    deleteStudent(indexValue);
                    Navigator.of(context).pop();
                  },
                  child: const Text("YES")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "NO",
                  )),
            ],
            
          );
        });
  }
}
