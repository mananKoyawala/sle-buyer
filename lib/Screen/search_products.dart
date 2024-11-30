import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sle_buyer/Package/PackageConstants.dart';
import 'package:sle_buyer/Package/Text_Button.dart';
import 'package:sle_buyer/Package/Utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sle_buyer/provider/search_product_provider.dart';

import '../Utils/Widgets/ProductContainer.dart';
import '../Utils/Widgets/ProductShimmerContainer.dart';

class SearchResultScreen extends ConsumerWidget with text_with_button, utils {
  SearchResultScreen(this.searchString, {super.key});
  final String searchString;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResultAsyncValue =
        ref.watch(searchResultProvider(searchString));

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          sizeH(45),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              iconButton(
                  onTap: () {
                    Navigation.pop();
                  },
                  icon: const Icon(Icons.arrow_back)),
              text(text: "Search result", fontSize: 26, fontWeight: 5),
              iconButton(
                  onTap: () {},
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 0,
                  )),
            ],
          ),
          sizeH10(),
          Expanded(
              child: CP(
            h: 16,
            child: searchResultAsyncValue.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(
                      child: Text("No products found!",
                          style: TextStyle(fontSize: 18)));
                }
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductContainer(ref: ref, product: products[index]);
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
                return Center(
                    child: text(text: "Failed to load products", fontSize: 18));
              },
            ),
          ))
        ],
      ),
    );
  }
}
