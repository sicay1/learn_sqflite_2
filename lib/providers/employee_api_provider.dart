import 'package:dio/dio.dart';
import 'package:learn_sqflite_2/models/employee_model.dart';
import 'package:learn_sqflite_2/providers/db_provider.dart';

class EmployeeApiProvider {
  Future<List<Employee>> getAllEmployee() async {
    var url = "http://demo8161595.mockable.io/employee";
    var resp = await Dio().get(url);

    List<Employee> listE = List<Employee>();

    (resp.data as List).map((e) {
      print('employee $e');
      listE.add(Employee.fromJson(e));
      DBProvider.db.createEmployee(Employee.fromJson(e));
    }).toList();

    return listE;
  }
}
