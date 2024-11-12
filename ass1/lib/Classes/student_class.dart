// To parse this JSON data, do
//
//     final Student = studentFromJson(jsonString);

import 'dart:convert';

import 'package:ass1/screens/search_student.dart';

Student studentFromJson(String str) => Student.fromJson(json.decode(str));

String studentToJson(Student data) => json.encode(data.toJson());

class Student {
  String id;
  String firstName;
  String lastName;
  String gender;
  String gpa;
  String level;
  String address;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.gpa,
    required this.level,
    required this.address,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    gender: json["gender"],
    gpa: json["gpa"],
    level: json["level"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "gender": gender,
    "gpa": gpa,
    "level": level,
    "address": address,
  };
}
