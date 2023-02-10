import 'package:hive/hive.dart';
part 'model.g.dart';


@HiveType(typeId: 1)
class StudentModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final String firstname;

  @HiveField(2)
  final String lastname;

  @HiveField(3)
  final String age;

  @HiveField(4)
  final String major;

  @HiveField(5)
  final String photo;

  StudentModel(
      {required this.firstname,
      required this.lastname,
      required this.age,
      required this.major,
      required this.photo,
      this.id});
}
