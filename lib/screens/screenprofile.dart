import 'dart:io';

import 'package:flutter/material.dart';
import 'package:studentrepo_sqflite/functions/db_functions.dart';
import 'package:studentrepo_sqflite/screens/screenhome.dart';
import 'package:studentrepo_sqflite/screens/screenupdate.dart';

class ScreenProfile extends StatefulWidget {
  final String firstname;
  final String lastname;
  final String age;
  final String major;
  final String photo;
  final int index;

  
  const ScreenProfile(
      {super.key,
      required this.firstname,
      required this.lastname,
      required this.age,
      required this.major,
      required this.photo,
      required this.index});

  @override
  State<ScreenProfile> createState() => _ScreenProfileState();

  
}



class _ScreenProfileState extends State<ScreenProfile> {

  @override
/*   void initState() {
    // TODO: implement initState
    super.initState();
    final String firstname;
  final String lastname;
  final String age;
  final String major;
  final String photo;
  final int index;


  } */
  @override
  Widget build(BuildContext context) {
    getallstudents();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Student Profile'),
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
            child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Text(
                    'Student Profile - ${widget.firstname}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage: FileImage(
                        File(
                          widget.photo,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'First Name:\t',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        widget.firstname,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Last Name: \t',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        widget.lastname,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Age:\t',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        widget.age,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Major:\t',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        widget.major,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton.icon(
                      onPressed: (() {
                        //setState(() {
                        Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(builder: ((context) {
                          return ScreenUpdate(
                              firstname: widget.firstname,
                              lastname: widget.lastname,
                              age: widget.age,
                              major: widget.major,
                              photo: widget.photo,
                              index: widget.index);
                        })));
                        //});
                      }),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'))
                ],
              ),
            ),
          ),
        )));
  }




}
