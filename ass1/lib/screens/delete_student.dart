import 'package:flutter/material.dart';

class DeleteStudentPage extends StatelessWidget {
  DeleteStudentPage({super.key});

  static const String id = "delete";

  // Controller for the student ID TextField
  final TextEditingController studentIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: (){Navigator.pop(context);},),
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
  void _deleteStudent(BuildContext context, String studentId) {
    // Replace this block with actual deletion logic (e.g., database operation)
    final isDeleted = _mockDeleteStudent(studentId);

    if (isDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Student with ID $studentId deleted successfully."),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      _showError(context, "Student with ID $studentId not found.");
    }

    // Clear the TextField after the operation
    studentIdController.clear();
  }

  // Mock function for deleting a student
  bool _mockDeleteStudent(String studentId) {
    // Simulate deletion (e.g., check against a list or database)
    // Here, we assume a student exists if their ID matches "1234".
    return studentId == "1234";
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
