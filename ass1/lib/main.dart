import 'package:ass1/screens/delete_student.dart';
import 'package:ass1/screens/student_data_page.dart';
import 'package:flutter/material.dart';
import 'screens/homepage.dart';
import 'screens/add_students_count_page.dart';
import 'screens/search_student.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: MyHomePage.id, // Start with MyHomePage
      routes: {
        MyHomePage.id: (context) => const MyHomePage(),
        AddStudentsCountPage.id: (context) => const AddStudentsCountPage(),
        DeleteStudentPage.id: (context) => DeleteStudentPage(),
        SearchStudentPage.id: (context) => SearchStudentPage(),
      },
    );
  }
}
