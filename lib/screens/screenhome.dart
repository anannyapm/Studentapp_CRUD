import 'package:flutter/material.dart';

import 'package:studentrepo_sqflite/screens/screenadd.dart';
import 'package:studentrepo_sqflite/screens/screensearch.dart';

import 'package:studentrepo_sqflite/screens/subscreens/listdata_widget.dart';

import '../functions/db_functions.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  @override
  Widget build(BuildContext context) {
    getallstudents();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Repository'),
        leading: GestureDetector(
          onTap: () {},
          child: const Icon(Icons.people_alt_rounded),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                showSearch(context: context, delegate: ScreenSearch(),);
              },
              child: const Icon(Icons.search),
            ),
          )
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (ctx) => const ScreenAdd()));
        },
        tooltip: 'Add Student',
        child: const Icon(Icons.add),
      ),

      body: const SafeArea(
          child: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListDataWidget(),
      )),
    );
  }
}
