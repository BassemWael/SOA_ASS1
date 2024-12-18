import 'package:flutter/material.dart';
import '../Classes/student_class.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
                labelText: "Search by First Name, Last Name, Level, Gender, Address, ID, or GPA",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _searchStudents(searchController.text.trim());
              },
              child: const Text("Search"),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Spacer(),
                Text("Search results: ${searchResults.length}"),
              ],
            ),
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

  void _searchStudents(String query) async {
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a search term."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final url = Uri.parse(
        'http://127.0.0.1:8080/api/students/search/ByKey?searchKey=$query');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Extract the students list from the response
        final List<dynamic> studentsData = responseData['students'];

        // Parse response data into a list of Student objects
        setState(() {
          searchResults = studentsData
              .map((json) => Student.fromJson(json as Map<String, dynamic>))
              .toList();
        });

        if (searchResults.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No students found."),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        // Handle unsuccessful response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Search failed. Error: ${response.body}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
