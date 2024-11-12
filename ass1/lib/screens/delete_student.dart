import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteStudentPage extends StatelessWidget {
  DeleteStudentPage({super.key});

  static const String id = "delete";

  final TextEditingController studentIdController = TextEditingController();

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
        title: const Text("Delete Student"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: studentIdController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "Student ID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final studentId = studentIdController.text.trim();
                  if (studentId.isEmpty) {
                    _showError(context, "Please enter a Student ID.");
                  } else {
                    _deleteStudent(context, studentId);
                  }
                },
                child: const Text("Delete Student"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle deletion
  Future<void> _deleteStudent(BuildContext context, String studentId) async {
    final url = Uri.parse("http://127.0.0.1:8080/api/students/$studentId");

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Student with ID $studentId deleted successfully."),
            backgroundColor: Colors.green,
          ),
        );
      } else if (response.statusCode == 404) {
        _showError(context, "Student with ID $studentId not found.");
      } else {
        _showError(context, "Failed to delete student. Try again later.");
      }
    } catch (e) {
      _showError(context, "An error occurred: $e");
    }

    studentIdController.clear();
  }

  // Function to display error messages
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
