import 'package:flutter/material.dart';

import '../Classes/student_class.dart';

class SearchStudentPage extends StatefulWidget {
  const SearchStudentPage({super.key});
  static const String id = "Search";
  @override
  State<SearchStudentPage> createState() => _SearchStudentPageState();
}

class _SearchStudentPageState extends State<SearchStudentPage> {
  final TextEditingController searchController = TextEditingController();

  List<Student> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _searchStudents(searchController.text.trim());
                    },
                    child: const Text("Search"),
                  ),
                )
              ],
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
                            title: Text(
                                "${student.firstName} ${student.lastName}"),
                            subtitle: Text(
                                "GPA: ${student.gpa}, Level: ${student.level}, Gender: ${student.gender}, Address: ${student.address}"),
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
    ///api function
  }
}
