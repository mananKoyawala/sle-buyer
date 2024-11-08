import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Package/PackageConstants.dart';
import '../../helper/product_api_helper.dart';
import '../../models/Product.dart';

class ProductState {
  final List<Product> products;
  final bool isLoading;

  ProductState({required this.products, required this.isLoading});
}

// Update ProductNotifier to use ProductState
class ProductNotifier extends AutoDisposeNotifier<ProductState> {
  final ProductApiHelper helper;
  bool _isInitialized = false;

  ProductNotifier() : helper = ProductApiHelper();

  @override
  ProductState build() {
    printDebug(">>>passed");
    state = ProductState(products: [], isLoading: true);
    init(); // Initialize data if necessary
    return state;
  }

  void init() {
    if (!_isInitialized) {
      fetchData();
      _isInitialized = true; // Set as initialized
    }
  }

  Future<void> fetchData() async {
    state = ProductState(products: state.products, isLoading: true);
    try {
      final products = await helper.getAllProducts();
      state = ProductState(products: products, isLoading: false);
    } catch (e) {
      state = ProductState(products: [], isLoading: false);
      printDebug(e.toString());
      toast("Failed to load products");
    }
  }

  void resetProducts() {
    state = ProductState(products: [], isLoading: false);
    _isInitialized = false; // Reset initialized state on logout
  }
}

final productsProvider =
    NotifierProvider.autoDispose<ProductNotifier, ProductState>(
        () => ProductNotifier());

class ProductUtils {
  final int page;
  final bool isFirstLoading;
  final bool hasNextPage;
  final bool isLoading;

  ProductUtils(
      {required this.page,
      required this.isFirstLoading,
      required this.hasNextPage,
      required this.isLoading});

  ProductUtils copyWith(
      {int? page, bool? isFirstLoading, bool? hasNextPage, bool? isLoading}) {
    return ProductUtils(
        page: page ?? this.page,
        isFirstLoading: isFirstLoading ?? this.isFirstLoading,
        hasNextPage: hasNextPage ?? this.hasNextPage,
        isLoading: isLoading ?? this.isLoading);
  }
}

class ProductNotifer1 extends StateNotifier<ProductUtils> {
  ProductNotifer1()
      : super(ProductUtils(
            page: 1,
            isFirstLoading: false,
            hasNextPage: true,
            isLoading: false));

  void changePage(int val) {
    state = state.copyWith(page: val);
  } // can change individual value
}
