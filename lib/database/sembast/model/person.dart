import 'package:flutter/cupertino.dart';

class Person {
  // Id will be gotten from the database.
  // It's automatically generated & unique for every stored Person.
  int id;

  final String name;
  final int age;
  final String role;

  Person({
    this.id,
    @required this.name,
    @required this.age,
    @required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'role': role,
    };
  }

  static Person fromMap(Map<String, dynamic> map) {
    return Person(
      name: map['name'],
      age: map['age'],
      role: map['role'],
    );
  }
}