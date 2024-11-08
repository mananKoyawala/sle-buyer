import '../helper/product_api_helper.dart';
import '../models/Product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchResultProvider =
    FutureProvider.family<List<Product>, String>((ref, searchString) async {
  final helper = ProductApiHelper();
  return await helper.searchProducts(searchString);
});
