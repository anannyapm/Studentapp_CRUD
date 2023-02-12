import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studentrepo_sqflite/functions/db_functions.dart';
import 'package:studentrepo_sqflite/model/model.dart';
import 'package:studentrepo_sqflite/screens/screenhome.dart';


class ScreenUpdate extends StatefulWidget {
  final String firstname;
  final String lastname;
  final String age;
  final String major;
  final dynamic photo;
  final int index;

  const ScreenUpdate(
      {super.key,
      required this.firstname,
      required this.lastname,
      required this.age,
      required this.major,
      required this.photo,
      required this.index});

  @override
  State<ScreenUpdate> createState() => _ScreenUpdateState();
}

class _ScreenUpdateState extends State<ScreenUpdate> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _majorController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _firstNameController = TextEditingController(text: widget.firstname);
    _lastNameController = TextEditingController(text: widget.lastname);
    _ageController = TextEditingController(text: widget.age);
    _majorController = TextEditingController(text: widget.major);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx2) => const ScreenHome()));
              },
              child: const Icon(Icons.close_rounded),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    const Text(
                      'Edit student details',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        _photo?.path == null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.blue,
                                child: CircleAvatar(
                                  radius: 48,
                                  backgroundImage:
                                      FileImage(File(widget.photo)),
                                ),
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.blue,
                                child: CircleAvatar(
                                  radius: 48,
                                  backgroundImage: FileImage(
                                    File(
                                      _photo!.path,
                                    ),
                                  ),
                                ),
                              ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: IconButton(
                              icon: const Icon(Icons.edit),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                getPhoto();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        hintText: '',
                        labelText: 'First Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First Name is empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20))),
                            hintText: '',
                            labelText: 'Last Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Last Name is empty!';
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(

                        //we can use keyboard controller to take int val
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20))),
                            hintText: 'Age',
                            labelText: 'Age'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Age is empty!';
                          } else if (int.tryParse(value) == null) {
                            return 'Age must be a number';
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        controller: _majorController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20))),
                            hintText: 'Major',
                            labelText: 'Major'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Major is empty!';
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              updateStudentDetail(context);
                            }
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('Save Data'),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  late String photoPathValue = '';
  Future<void> updateStudentDetail(ctx) async {
    if (photoPathValue == '') photoPathValue = widget.photo;

    final studentmodel = StudentModel(
        firstname: _firstNameController.text,
        lastname: _lastNameController.text,
        age: _ageController.text,
        major: _majorController.text,
        photo: photoPathValue);
    await updateList(widget.index, studentmodel);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(30),
        backgroundColor: Colors.green,
        content: Text(
          'Saved',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  File? _photo;
  Future<void> getPhoto() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);

    final photoTemp = File(photo!.path);
    setState(() {
      _photo = photoTemp;
      photoPathValue = _photo!.path;
    });
  }
}
