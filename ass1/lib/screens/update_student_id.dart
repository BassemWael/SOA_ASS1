import 'package:ass1/Classes/student_class.dart';
import 'package:ass1/screens/update_student.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateStudentID extends StatefulWidget {
  const UpdateStudentID({super.key});
  static const String id = "update student ID";

  @override
  State<UpdateStudentID> createState() => _UpdateStudentIDState();
}

class _UpdateStudentIDState extends State<UpdateStudentID> {
  final iDController = TextEditingController();
  int iD = 0;

  @override
  void dispose() {
    super.dispose();
    iDController.dispose();
  }

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
        title: Text("Update Student"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: iDController,
                  onChanged: (value) {
                    // Parse the input and update the count variable
                    setState(() {
                      iD = int.tryParse(value) ?? 0;
                      print("$iD");
                    });
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // Allows only digits
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Enter The ID',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 22),
            ElevatedButton(
              onPressed: () async {
                print("Student to be updated: $iD");
                if (iD == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter the ID of the student"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                final url = Uri.parse(
                    'http://127.0.0.1:8080/api/students/search/ByKey?searchKey=$iD');
                List<Student> searchResults = [];
                try {
                  final response = await http.get(url);
                  if (response.statusCode == 200) {
                    final Map<String, dynamic> responseData =
                        jsonDecode(response.body);

                    // Extract the students list from the response
                    final List<dynamic> studentsData = responseData['students'];

                    // Parse response data into a list of Student objects
                    setState(() {
                      searchResults =
                          studentsData.map((json) => Student.fromJson(json)).toList();
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
                  // Handle any exceptions or errors during the request
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("An error occurred: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                if (searchResults.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateStudentData(iD: iD),
                    ),
                  );
                }
              },
              child: Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}
