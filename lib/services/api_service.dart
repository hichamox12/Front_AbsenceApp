import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';

  static Future<dynamic> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );
    return json.decode(response.body);
  }

  static Future<List<dynamic>> fetchClasses() async {
    final response = await http.get(Uri.parse('$baseUrl/classes'));
    return json.decode(response.body);
  }
}
