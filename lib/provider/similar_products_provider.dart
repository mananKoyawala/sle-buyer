import '../helper/product_api_helper.dart';
import '../models/Product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductParams {
  final String seller_id;
  final String category;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductParams &&
        other.seller_id == seller_id &&
        other.category == category;
  }

  @override
  int get hashCode => seller_id.hashCode ^ category.hashCode;

  ProductParams({required this.seller_id, required this.category});
}

//  it will show similar products based on current product's seller_id and category
final getSimilarProductsProvider =
    FutureProvider.family<List<Product>, ProductParams>((ref, params) async {
  final helper = ProductApiHelper();
  return await helper.getAllSimilarProducts(params.seller_id, params.category);
});
