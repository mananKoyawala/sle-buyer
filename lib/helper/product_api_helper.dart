import 'dart:convert';
import '../../Package/PackageConstants.dart';
import '../../api/api_service.dart';
import '../../models/Product.dart';
import '../../provider/shared_preference.dart';

class ProductApiHelper {
  ApiService apiService = ApiService();
  SharedPreference pref = SharedPreference();

  // get all products for home page
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

  // serach products
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

  // get products by category
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

  // get similar products
  Future<List<Product>> getAllSimilarProducts(
      String seller_id, String category) async {
    await Future.delayed(const Duration(milliseconds: 150));
    printDebug(">>>seller_id ${pref.id}");

    final response =
        await apiService.getAllSimilarProducts(seller_id, category);
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

  Future<List<Product>> getBookmarkedProducts() async {
    await Future.delayed(const Duration(milliseconds: 150));

    final response = await apiService.getBookmarkedProducts(pref.id);
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

  Future<bool> addProductBookmark(String productId) async {
    await Future.delayed(const Duration(milliseconds: 150));

    final response = await apiService.addProductBookmark(productId, pref.id);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteProductBookmark(String productId) async {
    await Future.delayed(const Duration(milliseconds: 150));

    final response = await apiService.deleteProductBookmark(productId);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
