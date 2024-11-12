import 'package:flutter/material.dart';

class Student {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final double gpa;
  final int level;
  final String address;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.gpa,
    required this.level,
    required this.address,
  });
}

class SearchStudentPage extends StatefulWidget {
  const SearchStudentPage({super.key});
  static const String id = "Search";
  @override
  State<SearchStudentPage> createState() => _SearchStudentPageState();
}

class _SearchStudentPageState extends State<SearchStudentPage> {
  final TextEditingController searchController = TextEditingController();
  final List<Student> students = [
    Student(
        id: "1",
        firstName: "Alice",
        lastName: "Johnson",
        gender: "Female",
        gpa: 3.5,
        level: 2,
        address: "123 Main St"),
    Student(
        id: "2",
        firstName: "Bob",
        lastName: "Smith",
        gender: "Male",
        gpa: 3.8,
        level: 3,
        address: "456 Elm St"),
    Student(
        id: "3",
        firstName: "Alice",
        lastName: "Brown",
        gender: "Female",
        gpa: 3.0,
        level: 1,
        address: "789 Pine St"),
  ];

  List<Student> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: (){Navigator.pop(context);},),
        title: const Text("Search Students"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Search by First Name or GPA",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchStudents(value.trim());
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: searchResults.isNotEmpty
                  ? ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final student = searchResults[index];
                  return Card(
                    child: ListTile(
                      title: Text("${student.firstName} ${student.lastName}"),
                      subtitle: Text("GPA: ${student.gpa}, Level: ${student.level}, Gender: ${student.gender}, Address: ${student.address}"),
                      trailing: Text(student.id),
                    ),
                  );
                },
              )
                  : const Center(
                child: Text("No students found"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _searchStudents(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    setState(() {
      searchResults = students.where((student) {
        final isNameMatch = student.firstName.toLowerCase().contains(query.toLowerCase());
        final isGpaMatch = double.tryParse(query) != null &&
            student.gpa == double.parse(query);

        return isNameMatch || isGpaMatch;
      }).toList();
    });
  }
}
