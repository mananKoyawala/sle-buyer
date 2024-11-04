import 'package:flutter/material.dart';
import 'package:sle_buyer/provider/show_category_provider.dart';
import '../../Package/PackageConstants.dart';
import '../../Package/Text_Button.dart';
import '../../Package/Utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Utils/Widgets/ProductContainer.dart';
import '../Utils/Widgets/ProductShimmerContainer.dart';

class ShowCategoryScreen extends ConsumerWidget with text_with_button, utils {
  final String category;

  const ShowCategoryScreen({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the FutureProvider to fetch products for the given category
    final productsAsyncValue = ref.watch(productsByCategoryProvider(category));

    return Scaffold(
      body: CP(
        h: 16,
        v: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizeH25(),
            text(text: category, fontSize: 24),
            sizeH10(),
            Expanded(
              child: productsAsyncValue.when(
                data: (products) {
                  if (products.isEmpty) {
                    return const Center(
                        child: Text("No Products",
                            style: TextStyle(fontSize: 18)));
                  }
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductContainer(
                          ref: ref, product: products[index]);
                    },
                  );
                },
                loading: () => ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const ProductShimmerContainer();
                  },
                ),
                error: (error, stack) {
                  // Handle the error state
                  return Center(child: Text("Failed to load products: $error"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
