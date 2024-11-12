import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'student_data_page.dart';

class AddStudentsCountPage extends StatefulWidget {
  const AddStudentsCountPage({super.key});
  static const String id = "AddCount";

  @override
  State<AddStudentsCountPage> createState() => _AddStudentsCountPageState();
}

class _AddStudentsCountPageState extends State<AddStudentsCountPage> {
  final numberController = TextEditingController();
  int count = 0;

  @override
  void dispose() {
    super.dispose();
    numberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: (){Navigator.pop(context);},),
        title: Text("Number Of Students"),
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
                  controller: numberController,
                  onChanged: (value) {
                    // Parse the input and update the count variable
                    setState(() {
                      count = int.tryParse(value) ?? 0;
                      print("$count");
                    });
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Enter The Number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 22),
            ElevatedButton(
              onPressed: () {
                print("Confirmed number of students: $count");
                if(count==0){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please Enter a number greater than 0"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentDataPage(counter: count), // Replace 5 with your counter value
                  ),
                );

              },
              child: Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}
