import 'dart:convert';
import 'package:ass1/Classes/student_class.dart';
import 'package:ass1/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class UpdateStudentData extends StatefulWidget {
  const UpdateStudentData({super.key, required this.iD});
  static const String id = "Data Update Page";
  final int iD;

  @override
  State<UpdateStudentData> createState() => _UpdateStudentDataState();
}

class _UpdateStudentDataState extends State<UpdateStudentData> {
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController gpaController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  bool isLoading = false; // To manage the loading state
  int iD = 0;

  @override
  void initState() {
    super.initState();
    iD = widget.iD;
    fetchStudentData();
  }

  @override
  void dispose() {
    studentIdController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    genderController.dispose();
    gpaController.dispose();
    levelController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> fetchStudentData() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
        'http://127.0.0.1:8080/api/students/search/ByKey?searchKey=$iD');
    List<Student> searchResults = [];
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Extract the students list from the response
        final List<dynamic> studentsData = responseData['students'];

        if (studentsData.isNotEmpty) {
          // Assuming `searchResults` contains data parsed into a list of Student objects
          final searchResults =
              studentsData.map((json) => Student.fromJson(json)).toList();

          // Populate controllers with the data from index 0
          setState(() {
            studentIdController.text = searchResults[0].id.toString();
            firstNameController.text = searchResults[0].firstName;
            lastNameController.text = searchResults[0].lastName;
            genderController.text = searchResults[0].gender;
            gpaController.text = searchResults[0].gpa.toString();
            levelController.text = searchResults[0].level.toString();
            addressController.text = searchResults[0].address;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No students found."),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to fetch data. Error: ${response.body}"),
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Student Data Page'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Show loading spinner
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      disabled: true,
                      label: "Student ID",
                      controller: studentIdController,
                      keyboardType: TextInputType.text,
                    ),
                    _buildTextField(
                      disabled: false,
                      label: "First Name",
                      controller: firstNameController,
                      keyboardType: TextInputType.text,
                    ),
                    _buildTextField(
                      disabled: false,
                      label: "Last Name",
                      controller: lastNameController,
                      keyboardType: TextInputType.text,
                    ),
                    _buildTextField(
                      disabled: false,
                      label: "Gender",
                      controller: genderController,
                      keyboardType: TextInputType.text,
                    ),
                    _buildTextField(
                      disabled: false,
                      label: "GPA",
                      controller: gpaController,
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextField(
                      disabled: false,
                      label: "Level",
                      controller: levelController,
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextField(
                      disabled: false,
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Please fill in all fields before submitting."),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          _submitData();
                        },
                        child: const Text("update"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

Widget _buildTextField({
    required bool disabled,
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        readOnly: disabled,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
    ),
    );
  }

  Future<void> _submitData() async {
    final studentId = studentIdController.text;
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final gender = genderController.text;
    final gpa = double.tryParse(gpaController.text) ?? 0.0;
    final level = int.tryParse(levelController.text) ?? 0;
    final address = addressController.text;

    // Create the JSON data to be sent
    final Map<String, dynamic> studentData = {
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "gpa": gpa.toString(), // Assuming the server expects a string
      "level": level.toString(), // Assuming the server expects a string
      "address": address,
    };

    // Send the POST request
    final url = Uri.parse('http://127.0.0.1:8080/api/students/$studentId');
    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(studentData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Student data updated successfully."),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate if the counter is 1
        Navigator.pushNamedAndRemoveUntil(
          context,
          MyHomePage.id,
          (route) => false,
        );
      } else {
        // Show an error message if the response is not successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Failed to add student data. Error: ${response.body}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle any errors that occur during the request
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
