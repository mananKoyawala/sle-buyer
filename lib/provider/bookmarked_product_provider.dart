import '../Package/PackageConstants.dart';
import '../helper/product_api_helper.dart';
import '../models/Product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookmarkProductState {
  final List<Product> products;
  final bool isLoading;
  final bool
      isBookmarked; // updated for every time product details screen opened

  BookmarkProductState({
    required this.products,
    required this.isLoading,
    this.isBookmarked = false, // Default to false initially
  });

  BookmarkProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isBookmarked,
  }) {
    return BookmarkProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

// Update ProductNotifier to use ProductState
class BookmarkProductNotifier extends Notifier<BookmarkProductState> {
  final ProductApiHelper helper;

  BookmarkProductNotifier() : helper = ProductApiHelper();

  @override
  BookmarkProductState build() {
    printDebug(">>>passed");
    state = BookmarkProductState(products: [], isLoading: true);
    init(); // Initialize data if necessary
    return state;
  }

  void init() {
    fetchData();
  }

  Future<void> fetchData() async {
    state = BookmarkProductState(products: state.products, isLoading: true);
    try {
      final products = await helper.getBookmarkedProducts();
      state = BookmarkProductState(products: products, isLoading: false);
    } catch (e) {
      state = BookmarkProductState(products: [], isLoading: false);
      printDebug(e.toString());
      toast("Failed to load products");
    }
  }

  // Method to check if a product is bookmarked
  void isProductBookmarked(Product product) {
    final isProductInList = state.products
        .any((bookmarkedProduct) => bookmarkedProduct.id == product.id);
    state = state.copyWith(isBookmarked: isProductInList);
  }

  void updateProductBookmarked(bool val) {
    state = state.copyWith(isBookmarked: val);
  }

  void resetProducts() {
    state = BookmarkProductState(products: [], isLoading: false);
  }

  ProductApiHelper apiHelper = ProductApiHelper();

  addBookmarkProduct(WidgetRef ref, Product product) async {
    // toast("Add called");
    printDebug(">>>${product.id}");
    final isBookmarked = await apiHelper.addProductBookmark(product.id);
    if (isBookmarked) {
      toast("Product bookmarked");
      state = state.copyWith(isBookmarked: true);
      // fetchData();
      // * need to refresh the products
    } else {
      toast("Unable to bookmark product");
    }
  }

  deleteBookmarkProduct(WidgetRef ref, Product product) async {
    // toast("remove called");
    printDebug(">>>${product.product_bookmark_id}");
    final productBookmarked = ref
        .read(getAllBookmarkedProductsProvider)
        .products
        .firstWhere((element) => element.id == product.id);
    final isBookmarked = await apiHelper
        .deleteProductBookmark(productBookmarked.product_bookmark_id);
    if (isBookmarked) {
      toast("Bookmark removed");
      // Ensure `isBookmarked` is updated
      state = state.copyWith(isBookmarked: false);
      // fetchData();
      // * need to refresh the products
    } else {
      toast("Unable to remove bookmark");
    }
  }
}

final getAllBookmarkedProductsProvider =
    NotifierProvider<BookmarkProductNotifier, BookmarkProductState>(
        () => BookmarkProductNotifier());
