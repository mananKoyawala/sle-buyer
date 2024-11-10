import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sle_buyer/Package/PackageConstants.dart';

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
    String encodedCategory =
        Uri.encodeComponent(category); // URL encode the category
    printDebug(">>> '$baseURL/products/category?category=$encodedCategory'");
    return await http
        .get(Uri.parse('$baseURL/products/category?category=$encodedCategory'));
  }

  Future<http.Response> getAllSimilarProducts(
      String seller_id, String category) async {
    String encodedCategory =
        Uri.encodeComponent(category); // URL encode the category
    printDebug(">>> '$baseURL/products/category?category=$encodedCategory'");
    return await http
        .get(Uri.parse('$baseURL/products/category?category=$encodedCategory'));
  }

  Future<http.Response> searchProducts(String searchString) async {
    String encodedSearchString = Uri.encodeComponent(searchString);
    return await http
        .get(Uri.parse('$baseURL/products/search/$encodedSearchString'));
  }
}
