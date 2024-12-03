import 'package:flutter/material.dart';
import '../Classes/student_class.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ShowStudents extends StatefulWidget {
  const ShowStudents({super.key});
  static const String id = "Show Students Page";

  @override
  State<ShowStudents> createState() => _ShowStudentsState();
}

class _ShowStudentsState extends State<ShowStudents> {
  // Define the dropdown options
  final List<String> dropdownItems = [
    'GPA',
    'ID',
    'FirstName',
    'LastName',
    'Level',
    'Address',
    'Gender',
  ];

  // State variable to hold the selected value
String? selectedItem;
List<Student> searchResults = [];
bool aord = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sort Students'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add padding to position the dropdown at the top
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              key: ValueKey(selectedItem), // Ensure a unique key
              value: selectedItem,
              decoration: InputDecoration(
                labelText: 'Select an option',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: dropdownItems.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _searchStudents(newValue, aord);
                }

                setState(() {
                  selectedItem = newValue;
                });
              },
           
            ),
           ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    if (aord == true) {
                      aord = false;
                    } else {
                      aord = true;
                    }
                  });
                  if (selectedItem != null) {
                    _searchStudents(selectedItem!, aord);
                  }
                },
                icon: aord == true
                    ? const Icon(Icons.arrow_drop_up_rounded)
                    : const Icon(Icons.arrow_drop_down_rounded)),
                    ),
          // Example content or additional UI components
          Expanded(
            child: selectedItem == null
                ? const Center(
                    child: Text(
                      'Please select an option from the dropdown',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Expanded(
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
          ),
        ],
      ),
    );
  }

  void _searchStudents(String query,bool aord) async {
    if (query.isEmpty) {
      // Display an error message if the search field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a search term."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final url =
        Uri.parse('http://127.0.0.1:8080/api/students/sort?attribute=$query&ascending=$aord');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Parse response data into a list of Student objects
        setState(() {
          searchResults = data.map((json) => Student.fromJson(json)).toList();
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
  }
}
