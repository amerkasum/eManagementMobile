import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHandler {
  final String baseUrl;

  ApiHandler({required this.baseUrl});

  Future<dynamic> getRequest(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    return _processResponse(response);
  }

  Future<dynamic> postRequest(String endpoint, {Map<String, dynamic>? body}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(body), 
    );
    return _processResponse(response);
  }

  Future<dynamic> putRequest(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  Future<dynamic> deleteRequest(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    return _processResponse(response);
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
