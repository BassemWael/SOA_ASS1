package org.example.studentxmlapp.Controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.example.studentxmlapp.Services.StudentService;
import org.example.studentxmlapp.Model.StudentData;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/students")
public class StudentController {

    @Autowired
    private StudentService studentService;

    // Add Student
    @PostMapping
    public ResponseEntity<String> addStudent(@RequestBody StudentData student) {
        String result = studentService.addStudent(student);
        if ("Student added successfully.".equals(result)) {
            return ResponseEntity.ok(result);
        }
        return ResponseEntity.badRequest().body(result);
    }

    // Update Student
    @PutMapping("/{id}")
    public ResponseEntity<String> updateStudent(@PathVariable String id, @RequestBody StudentData newDetails) {
        String result = studentService.updateStudent(id, newDetails);
        if ("Student updated successfully.".equals(result)) {
            return ResponseEntity.ok(result);
        }
        return ResponseEntity.status(404).body(result);
    }


    //  Search
    @GetMapping("/search")
    public ResponseEntity<?> searchStudentsByMultiAttributes(@RequestParam Map<String, String> filters) {
        List<StudentData> results = studentService.searchStudentsByMultiAttributes(filters);
        int count = results.size();

        if (count == 0) {
            return ResponseEntity.status(404).body("No students found.");
        }

        Map<String, Object> response = new HashMap<>();
        response.put("count", count);
        response.put("students", results);

        return ResponseEntity.ok(response);
    }

    @GetMapping("/search/ByKey")
    public ResponseEntity<?> searchStudents(@RequestParam String searchKey) {
        List<StudentData> results = studentService.searchStudentsByASearchKey(searchKey);
        int count = results.size();

        if (results.isEmpty()) {
            return ResponseEntity.status(404).body("No students found.");
        }

        Map<String, Object> response = new HashMap<>();
        response.put("count", count);
        response.put("students", results);

        return ResponseEntity.ok(response);
    }



    // Delete Student
    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteStudent(@PathVariable String id) {
        boolean isDeleted = studentService.deleteStudent(id);
        if (isDeleted) {
            return ResponseEntity.ok("Student deleted successfully.");
        } else {
            return ResponseEntity.status(404).body("Student not found.");
        }
    }

    // Sort Students
    @GetMapping("/sort")
    public ResponseEntity<List<StudentData>> sortStudents(
            @RequestParam String attribute,
            @RequestParam(defaultValue = "true") boolean ascending) {
        List<StudentData> sortedStudents = studentService.sortStudents(attribute, ascending);
        return ResponseEntity.ok(sortedStudents);
    }
}
