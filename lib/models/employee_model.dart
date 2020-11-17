import 'dart:convert';

List<Employee> emplyeeFromJson(String str) =>
    List<Employee>.from(jsonDecode(str).map((x) => Employee.fromJson(x)));

String employeeToJson(List<Employee> data) =>
    jsonEncode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employee {
  int id;
  String email;
  String fName;
  String lName;
  String avatar;

  Employee({this.id, this.email, this.fName, this.lName, this.avatar});

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        email: json["email"],
        fName: json["firstName"],
        lName: json["lastName"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        // "id": id, no need because of auto increament
        "email": email,
        "firstName": fName,
        "lastName": lName,
        "avatar": avatar,
      };
}
