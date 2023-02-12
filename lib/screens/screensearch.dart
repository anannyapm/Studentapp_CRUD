import 'dart:io';

import 'package:flutter/material.dart';
import 'package:studentrepo_sqflite/functions/db_functions.dart';
import 'package:studentrepo_sqflite/model/model.dart';
import 'package:studentrepo_sqflite/screens/screenprofile.dart';
import 'package:studentrepo_sqflite/screens/subscreens/listdata_widget.dart';

class ScreenSearch extends SearchDelegate {

    // first override to clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }


  //to pop out of the search menu
  @override
  Widget buildLeading(BuildContext context) {
    
    // TODO: implement buildLeading
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // for closing the search page and going back
      },
    );
  }

//to show query result
  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    //bool output = true;
    return ValueListenableBuilder(
      valueListenable: studentListNotifier,
      builder: ((BuildContext context, List<StudentModel> studentList,
          Widget? child) {
        return ListView.builder(
          itemBuilder: (ctx, index) {
            final data = studentList[index];
            String nameVal = data.firstname + data.lastname;
            if (nameVal.toLowerCase().contains(query.toLowerCase())) {
              print('matched!!!!');
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) {
                            return const ListDataWidget();
                          }),
                        ),
                      );
                    },
                    title: Text("${data.firstname} ${data.lastname}"),
                    leading: CircleAvatar(
                      backgroundImage: FileImage(File(data.photo)),
                    ),
                  ),
                  const Divider()
                ],
              );
            } else {
              print('no result');
              //output = false;
            }
          },
          itemCount: studentList.length,
        
        );
      }),
      
    );
  }


  //to show the querying process ie suggestions at the runtime 
  @override
  Widget buildSuggestions(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: studentListNotifier,
      builder: ((BuildContext context, List<StudentModel> studentList,
          Widget? child) {
        return ListView.builder(
          itemBuilder: (ctx, index) {
            final data = studentList[index];
            String nameVal = data.firstname + data.lastname;
            if (nameVal.contains(query)) {
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((context) {
                            return ScreenProfile(
                                firstname: data.firstname,
                                lastname: data.lastname,
                                age: data.age,
                                major: data.major,
                                index: index,
                                photo: data.photo);
                          }),
                        ),
                      );
                    },
                    title: Text("${data.firstname} ${data.lastname}"),
                    leading: CircleAvatar(
                      backgroundImage: FileImage(File(data.photo)),
                    ),
                  ),
                  const Divider()
                ],
              );
            } else {
              return Container();
            }
          },
          itemCount: studentList.length,
        );
      }),
    );
  }
}
