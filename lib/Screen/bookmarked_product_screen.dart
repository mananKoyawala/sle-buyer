import 'package:flutter/material.dart';
import '../../Package/PackageConstants.dart';
import '../../Package/Text_Button.dart';
import '../../Package/Utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Utils/Widgets/ProductContainer.dart';
import '../provider/bookmarked_product_provider.dart';

class BookmarkedProductScreen extends ConsumerWidget
    with text_with_button, utils {
  const BookmarkedProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookMarkedProducts = ref.watch(getAllBookmarkedProductsProvider);

    return Scaffold(
      body: CP(
        h: 16,
        v: 16,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizeH25(),
              Row(
                children: [
                  iconButton(
                      onTap: () {
                        Navigation.pop();
                      },
                      icon: const Icon(Icons.arrow_back)),
                  text(text: "My Bookmarks", fontSize: 24),
                ],
              ),
              sizeH10(),
              bookMarkedProducts.isLoading
                  ? Container()
                  : bookMarkedProducts.products.isEmpty
                      ? SizedBox(
                          height: 250,
                          child: Center(
                            child: text(
                                text: "There is no bookmarks", fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: bookMarkedProducts.products.length,
                          itemBuilder: (context, index) {
                            return ProductContainer(
                              ref: ref,
                              product: bookMarkedProducts.products[index],
                            );
                          })
            ],
          ),
        ),
      ),
    );
  }
}
