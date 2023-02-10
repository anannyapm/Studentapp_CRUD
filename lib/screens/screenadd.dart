import 'dart:io';

import 'package:flutter/material.dart';
import 'package:studentrepo_sqflite/screens/screenhome.dart';
import 'package:image_picker/image_picker.dart';
import '../functions/db_functions.dart';
import '../model/model.dart';

class ScreenAdd extends StatefulWidget {
  const ScreenAdd({super.key});

  @override
  State<ScreenAdd> createState() => _ScreenEditState();
}

class _ScreenEditState extends State<ScreenAdd> {
  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _ageController = TextEditingController();

  final _majorController = TextEditingController();

  bool imageAlert = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Student'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                return Navigator.of(context).pop();
              },
              child: const Icon(Icons.close_rounded),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //check if photo null and assign photo to be shown accordingly
                  _photo?.path == null
                      ? const CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              'https://cdn-icons-png.flaticon.com/512/3237/3237472.png'),
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(
                            File(
                              _photo!.path,
                            ),
                          ),
                          radius: 60,
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          elevation: 10,//shadow
                        ),
                        onPressed: () {
                          getPhoto();
                        },
                        icon: const Icon(
                          Icons.image_outlined,
                          size: Checkbox.width,
                        ),
                        label: const Text(
                          'Add An Image',style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                        border:OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(20)),), hintText: 'First Name',labelText: 'First Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First Name is empty!';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(20))), hintText: 'Last Name',labelText: 'Last Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last Name is empty!';
                        } else {
                          return null;
                        }
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
      
                      //we can use keyboard controller to take int val
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(20))), hintText: 'Age',labelText: 'Age'),
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
                    height: 15,
                  ),
                  TextFormField(
                      controller: _majorController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(20))), hintText: 'Major',labelText: 'Major'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Major is empty!';
                        } else {
                          return null;
                        }
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      
                      onPressed: () {
                        
                        if (_formKey.currentState!.validate() &&
                            _photo != null) {
                          addStudentToModel();
                        } else if (_photo == null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text(
                            'Please add profile image!',
                            style: TextStyle(color: Colors.white),
                          )));
                        } else {
                          print('Empty field found');
                          imageAlert = true;
                        }
                      },
                      child: const Text('Add Student'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  popDialogueBox() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Success"),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20),
            actionsOverflowButtonSpacing: 20,
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (ctx) {
                      return const ScreenHome();
                    }));
                  },
                  child: const Text("Back")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Add New")),
            ],
            content: const Text("Saved successfully"),
          );
        });
  }

//add value to student class model

  Future<void> addStudentToModel() async {
    final _firstname = _firstNameController.text.trim();
    final _lastname = _lastNameController.text.trim();
    final _age = _ageController.text.trim();
    final _major = _majorController.text.trim();
    final _image = _photo;

    if (_photo!.path.isEmpty ||
        _lastname.isEmpty ||
        _firstname.isEmpty ||
        _age.isEmpty ||
        _major.isEmpty) {
      return;
    } else {
      //reset fields
      _firstNameController.text = '';
      _lastNameController.text = '';
      _ageController.text = '';
      _majorController.text = '';
      _photo = null;
      setState(() {
        popDialogueBox(); //to show success message
      });
    }

    final studentObject = StudentModel(
        firstname: _firstname,
        lastname: _lastname,
        age: _age,
        major: _major,
        photo: _image!.path);
    print("$_firstname $_lastname $_age  $_major");

    addStudent(studentObject);
  }

  //photo picker function using dart io

  File? _photo;
  Future<void> getPhoto() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (photo == null) {
    } else {
      final photoTemp = File(photo.path);
      setState(
        () {
          _photo = photoTemp;
        },
      );
    }
  }
}
