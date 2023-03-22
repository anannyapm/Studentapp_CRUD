import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

import '../model/model.dart';

//studentListNotifier(object of valuenotifier) contains list type values passed in via ValueNotifier constructor
ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);

Future<void> addStudent(StudentModel value) async {
  final studentDB = await Hive.openBox<StudentModel>('student_db');

  //add value into hive
  final id = await studentDB.add(value);

  //assign id of value as the the id generated and returned by hive when value is added
  value.id = id;

  //add value into studentListNotifier list and then notify the widgets listening to it via notifyListneres.
  studentListNotifier.value.add(value);
  studentListNotifier.notifyListeners();
}

Future<void> getallstudents() async {
  final studentDB = await Hive.openBox<StudentModel>('student_db');
  studentListNotifier.value.clear();

  studentListNotifier.value.addAll(studentDB.values);
  studentListNotifier.notifyListeners();
}

Future<void> deleteStudent(int id) async {
  final studentDB = await Hive.openBox<StudentModel>('student_db');

  await studentDB.deleteAt(id);
  
  getallstudents();
}

Future<void> updateList(int id, StudentModel value) async {
  final studentDatabase = await Hive.openBox<StudentModel>('student_db');
  studentDatabase.putAt(id, value);
  getallstudents();
}
