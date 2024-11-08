import 'dart:convert';
import '../../Package/PackageConstants.dart';
import '../../api/api_service.dart';
import '../../models/Product.dart';
import '../../provider/shared_preference.dart';

class ProductApiHelper {
  ApiService apiService = ApiService();
  SharedPreference pref = SharedPreference();

  Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 150));
    printDebug(">>>seller_id ${pref.id}");

    final response = await apiService.getAllProducts();
    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final dataList = responseBody["data"] as List<dynamic>? ?? [];
      final List<Product> products =
          dataList.map((data) => Product.fromJson(data)).toList();

      printDebug(">>>${products.length}");
      return products;
    } else {
      final data = responseBody["error"] ?? '';
      printDebug(">>>$data");
      return [];
    }
  }

  // * serach products
  Future<List<Product>> searchProducts(String searchString) async {
    await Future.delayed(const Duration(milliseconds: 150));
    printDebug(">>>seller_id ${pref.id}");

    final response = await apiService.searchProducts(searchString);
    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final dataList = responseBody["data"] as List<dynamic>? ?? [];
      final List<Product> products =
          dataList.map((data) => Product.fromJson(data)).toList();

      printDebug(">>>${products.length}");
      return products;
    } else {
      final data = responseBody["error"] ?? '';
      printDebug(">>>$data");
      return [];
    }
  }

  // * get products by category
  Future<List<Product>> getAllProductsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 150));
    printDebug(">>>seller_id ${pref.id}");

    final response = await apiService.getAllProductsByCategory(category);
    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final dataList = responseBody["data"] as List<dynamic>? ?? [];
      final List<Product> products =
          dataList.map((data) => Product.fromJson(data)).toList();

      printDebug(">>>${products.length}");
      return products;
    } else {
      final data = responseBody["error"] ?? '';
      printDebug(">>>$data");
      return [];
    }
  }
}
