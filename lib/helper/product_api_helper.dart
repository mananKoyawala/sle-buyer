import 'dart:convert';
import '../../Package/PackageConstants.dart';
import '../../api/api_service.dart';
import '../../models/Product.dart';
import '../../provider/shared_preference.dart';
import '../Utils/constants.dart';

class ProductApiHelper {
  ApiService apiService = ApiService();
  SharedPreference pref = SharedPreference();

  // get all products for home page
  Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 150));
    printDebug(">>>seller_id ${pref.id}");

    final response =
        await apiService.performRequest(method: 'GET', endpoint: '/products');

    try {
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
    } catch (e) {
      printDebug("Error during get all products: $e");
      showSomeThingWrongSnackBar();
      return [];
    }
  }

  // serach products
  Future<List<Product>> searchProducts(String searchString) async {
    await Future.delayed(const Duration(milliseconds: 150));
    printDebug(">>>seller_id ${pref.id}");
    String encodedSearchString = Uri.encodeComponent(searchString);
    final response = await apiService.performRequest(
        method: 'GET', endpoint: '/products/search/$encodedSearchString');
    final responseBody = jsonDecode(response.body);

    try {
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
    } catch (e) {
      printDebug("Error during search products: $e");
      showSomeThingWrongSnackBar();
      return [];
    }
  }

  // get products by category
  Future<List<Product>> getAllProductsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 150));
    printDebug(">>>seller_id ${pref.id}");
    String encodedCategory = Uri.encodeComponent(category);
    final response = await apiService.performRequest(
        method: 'GET',
        endpoint: '/products/category?category=$encodedCategory');
    final responseBody = jsonDecode(response.body);

    try {
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
    } catch (e) {
      printDebug("Error during get all products by category: $e");
      showSomeThingWrongSnackBar();
      return [];
    }
  }

  // get similar products
  Future<List<Product>> getAllSimilarProducts(
      String seller_id, String category) async {
    await Future.delayed(const Duration(milliseconds: 150));
    printDebug(">>>seller_id ${pref.id}");
    String encodedCategory = Uri.encodeComponent(category);
    final response = await apiService.performRequest(
        method: 'GET',
        endpoint: '/products/category?category=$encodedCategory');
    final responseBody = jsonDecode(response.body);

    try {
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
    } catch (e) {
      printDebug("Error during get all similar products: $e");
      showSomeThingWrongSnackBar();
      return [];
    }
  }

  Future<List<Product>> getBookmarkedProducts() async {
    await Future.delayed(const Duration(milliseconds: 150));

    final response = await apiService.performRequest(
        method: 'GET', endpoint: '/bookmarks/all/${pref.id}');
    final responseBody = jsonDecode(response.body);

    try {
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
    } catch (e) {
      printDebug("Error during get bookmarked products: $e");
      showSomeThingWrongSnackBar();
      return [];
    }
  }

  Future<bool> addProductBookmark(String productId) async {
    await Future.delayed(const Duration(milliseconds: 150));

    final response = await apiService.performRequest(
        method: 'GET', endpoint: '/bookmarks/$productId/${pref.id}');

    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug("Error during add product bookmark: $e");
      showSomeThingWrongSnackBar();
      return false;
    }
  }

  Future<bool> deleteProductBookmark(String productId) async {
    await Future.delayed(const Duration(milliseconds: 150));

    final response = await apiService.performRequest(
        method: 'DELETE', endpoint: '/bookmarks/$productId');

    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug("Error during delete product bookmark: $e");
      showSomeThingWrongSnackBar();
      return false;
    }
  }
}
