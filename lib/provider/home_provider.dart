import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Package/PackageConstants.dart';
import '../../helper/product_api_helper.dart';
import '../../models/Product.dart';
import '../connection/connectivity_helper.dart';

class ProductState {
  final List<Product> products;
  final bool isLoading;
  final String? retryMessage;

  ProductState(
      {required this.products, required this.isLoading, this.retryMessage});
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
    state = ProductState(
      products: state.products,
      isLoading: true,
    );

    // Check internet connectivity before making the API call
    final hasInternet = await ConnectivityHelper.hasInternetConnection();
    if (!hasInternet) {
      printDebug(">>> No internet connection");
      state = ProductState(
        products: [],
        isLoading: false,
        retryMessage:
            'No internet connection. \nPlease check your connection and retry.',
      );
      return;
    }
    try {
      final products = await helper.getAllProducts();
      state = ProductState(
          products: products,
          isLoading: false,
          retryMessage: 'There is no products.');
    } catch (e) {
      state = ProductState(
          products: [],
          isLoading: false,
          retryMessage: 'Failed to load products. \nTap Retry to try again.');
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
