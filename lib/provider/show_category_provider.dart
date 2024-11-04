import '../helper/product_api_helper.dart';
import '../models/Product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a FutureProvider for fetching products by category
final productsByCategoryProvider =
    FutureProvider.family<List<Product>, String>((ref, category) async {
  final helper = ProductApiHelper();
  return await helper.getAllProductsByCategory(category);
});
