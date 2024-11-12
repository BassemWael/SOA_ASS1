import 'package:ass1/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentDataPage extends StatefulWidget {
  const StudentDataPage({super.key, required this.counter});
  static const String id = "DataPage";
  final int counter;

  @override
  State<StudentDataPage> createState() => _StudentDataPageState();
}

class _StudentDataPageState extends State<StudentDataPage> {
  // Controllers for the text fields
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController gpaController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    // Dispose of controllers when the widget is disposed
    studentIdController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    genderController.dispose();
    gpaController.dispose();
    levelController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int counter = widget.counter;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Student Data Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: "Student ID",
                controller: studentIdController,
                keyboardType: TextInputType.text,
              ),
              _buildTextField(
                label: "First Name",
                controller: firstNameController,
                keyboardType: TextInputType.text,
              ),
              _buildTextField(
                label: "Last Name",
                controller: lastNameController,
                keyboardType: TextInputType.text,
              ),
              _buildTextField(
                label: "Gender",
                controller: genderController,
                keyboardType: TextInputType.text,
              ),
              _buildTextField(
                label: "GPA",
                controller: gpaController,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                label: "Level",
                controller: levelController,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                label: "Address",
                controller: addressController,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (studentIdController.text.isEmpty ||
                        firstNameController.text.isEmpty ||
                        lastNameController.text.isEmpty ||
                        genderController.text.isEmpty ||
                        gpaController.text.isEmpty ||
                        levelController.text.isEmpty ||
                        addressController.text.isEmpty) {
                      // Show an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Please fill in all fields before submitting."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return; // Stop further execution
                    }
                    _submitData(counter);
                    counter--;
                    print(counter);
                  },
                  child: const Text("Next Student"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: keyboardType == TextInputType.text
          ? TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
            )
          : TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow("."),
              ],
            ),
    );
  }

  void _submitData(int counter) {
    // Example: Retrieve the data from controllers and process it
    final studentId = studentIdController.text;
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final gender = genderController.text;
    final gpa = double.tryParse(gpaController.text) ?? 0.0;
    final level = int.tryParse(levelController.text) ?? 0;
    final address = addressController.text;

    // Print the values (replace with actual submission logic)
    print("Student ID: $studentId");
    print("First Name: $firstName");
    print("Last Name: $lastName");
    print("Gender: $gender");
    print("GPA: $gpa");
    print("Level: $level");
    print("Address: $address");
    if (counter == 1) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        MyHomePage.id,
            (route) => false,
      );
    }
    _resetFields();
    // Add any validation or submission logic here
  }

  void _resetFields() {
    // Clear all text fields
    studentIdController.clear();
    firstNameController.clear();
    lastNameController.clear();
    genderController.clear();
    gpaController.clear();
    levelController.clear();
    addressController.clear();
  }
}
