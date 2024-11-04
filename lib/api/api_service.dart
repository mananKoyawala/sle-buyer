import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String baseURL = dotenv.env['API_URL'] ?? '';

  Future<http.Response> buyerLogin(String phone) async {
    return await http.post(
      Uri.parse('$baseURL/buyers/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {'b_phone': phone, 'b_password': "Admin@123"},
        // here password is not required but provided beacuse of backend misconfigurations
      ),
    );
  }

  Future<http.Response> buyerSignup(
    String first_name,
    last_name,
    email,
    image_url,
    address,
    phone,
    dob,
  ) async {
    return await http.post(
      Uri.parse('$baseURL/buyers/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          'b_first_name': first_name,
          'b_last_name': last_name,
          'b_email': email,
          'b_password': "Admin@123",
          'b_image_url': image_url,
          'b_address': address,
          'b_phone': phone,
          'b_dob': dob,
        },
      ),
    );
  }

  Future<http.Response> isBuyerExists(String phone) async {
    return await http.get(
      Uri.parse('$baseURL/buyers/phone/$phone'),
    );
  }

  Future<http.Response> getProductByID(String product_id) async {
    return await http.get(Uri.parse('$baseURL/products/$product_id'));
  }

  Future<http.Response> getAllProducts() async {
    return await http.get(Uri.parse('$baseURL/products'));
  }

  Future<http.Response> getAllProductsByCategory(String category) async {
    return await http
        .get(Uri.parse('$baseURL/products/category?category=$category'));
  }
}
