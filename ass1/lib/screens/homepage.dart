import 'package:ass1/screens/add_students_count_page.dart';
import 'package:ass1/screens/delete_student.dart';
import 'package:ass1/screens/sort_students.dart';
import 'package:ass1/screens/update_student_id.dart';
import 'package:flutter/material.dart';

import 'search_student.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  static const String id = "Home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AddStudentsCountPage.id,
                  );
                },
                child: const Text("Add Students")),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(
                context,
                SearchStudentPage.id,
              );
            }, child: const Text("Search")),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    UpdateStudentID.id,
                  );
                },
                child: const Text("Update Student")),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(
                context,
                ShowStudents.id,
              );
            }, child: const Text("Sort Students")),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateColor.resolveWith((states) => Colors.red)),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    DeleteStudentPage.id,
                  );
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
