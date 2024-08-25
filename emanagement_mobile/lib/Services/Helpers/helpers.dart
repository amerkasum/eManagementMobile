import 'package:emanagement_mobile/Models/Helpers/select_list_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String apiUrl = "https://localhost:5001"; // Replace with your actual API URL

  Future<List<SelectListHelper>> fetchContractTypes() async {
    final response = await http.get(Uri.parse('$apiUrl/api/ContractType/GetAll'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => SelectListHelper.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load contract types');
    }
  }

  Future<List<SelectListHelper>> fetchRoles() async {
    final response = await http.get(Uri.parse('$apiUrl/api/Roles/GetAll'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => SelectListHelper.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load contract types');
    }
  }

  Future<List<SelectListHelper>> fetchCities() async {
    final response = await http.get(Uri.parse('$apiUrl/api/Cities/GetAll'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => SelectListHelper.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load contract types');
    }
  }

  Future<List<SelectListHelper>> fetchShifts() async {
    final response = await http.get(Uri.parse('$apiUrl/api/Shift/GetAll'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => SelectListHelper.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load shifts');
    }
  }

  Future<List<SelectListHelper>> fetchPositions() async {
    final response = await http.get(Uri.parse('$apiUrl/api/Position/GetAll'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => SelectListHelper.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load positions');
    }
  }

  Future<List<SelectListHelper>> fetchUsers() async {
    final response = await http.get(Uri.parse('$apiUrl/api/Users/GetAll'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => SelectListHelper.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load positions');
    }
  }

  Future<List<SelectListHelper>> fetchTaskPriosities() async {
    final response = await http.get(Uri.parse('$apiUrl/api/TaskPriorities/GetAll'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => SelectListHelper.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load positions');
    }
  }

  Future<List<SelectListHelper>> fetchEventStatuses() async {
    final response = await http.get(Uri.parse('$apiUrl/api/EventStatuses/GetAll'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => SelectListHelper.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load positions');
    }
  }
}
