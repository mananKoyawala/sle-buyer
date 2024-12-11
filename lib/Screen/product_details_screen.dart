import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sle_buyer/Package/PackageConstants.dart';
import 'package:sle_buyer/Package/Text_Button.dart';
import 'package:sle_buyer/Package/Utils.dart';
import 'package:sle_buyer/models/Product.dart';
import 'package:sle_buyer/provider/similar_products_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Utils/Widgets/ProductContainer.dart';
import '../provider/bookmarked_product_provider.dart';

class ProductDetailsScreen extends ConsumerWidget with text_with_button, utils {
  ProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getSimilarProducts = ref.watch(getSimilarProductsProvider(
        ProductParams(
            seller_id: product.seller_id, category: product.category)));
    final bookMarked = ref.watch(getAllBookmarkedProductsProvider);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(getAllBookmarkedProductsProvider.notifier).fetchData();
          return;
        }
      },
      child: Scaffold(
          body: CP(
        h: 16,
        child: ListView(
          padding: const EdgeInsets.all(0),
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
                text(
                    text: "Product Details",
                    fontSize: 26,
                    // textAlign: TextAlign.center,
                    fontWeight: 5),
                iconButton(
                    onTap: () {},
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 0,
                    )),
              ],
            ),
            sizeH10(),
            Container(
              height: getScreenHeight(context) * 0.4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: radius(
                  30,
                ),
              ),
              child: ClipRRect(
                borderRadius: radius(30),
                child: Image.network(
                  product.image_url,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: text(text: "No Image", fontSize: 18));
                  },
                ),
              ),
            ),
            sizeH25(),
            overFlowText(
              h: 25,
              w: getScreenWidth(context),
              text: product.name,
              fontSize: 18,
              fontWeight: 7,
            ),
            sizeH10(),
            overFlowText(
                h: 20,
                w: getScreenWidth(context),
                text: product.brand,
                fontSize: 16,
                fontWeight: 3),
            sizeH10(),
            text(
                text: "₹${product.price} / piece",
                fontSize: 16,
                textColor: Colors.green,
                fontWeight: 5),
            sizeH10(),
            text(
                text: "Minimum quantity for order : ${product.quantity}",
                fontSize: 14,
                fontWeight: 5),
            sizeH25(),
            Row(
              children: [
                text(
                  text: 'Owner : ',
                  fontSize: 16,
                ),
                text(
                    text: product.seller_first_name,
                    fontSize: 18,
                    fontWeight: 5),
              ],
            ),
            sizeH25(),
            Row(
              children: [
                Expanded(
                  child: simpleButton(
                      borderRadius: 20,
                      prefixIcon: const Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                      prefixIconGap: 5,
                      height: 50,
                      onTap: () async {
                        final Uri phoneUri =
                            Uri(scheme: 'tel', path: product.seller_phone);
                        if (await canLaunchUrl(phoneUri)) {
                          await launchUrl(phoneUri);
                        } else {
                          toast("Unable to call right now");
                        }
                      },
                      title: text(
                          text: "Call now",
                          fontSize: 16,
                          textColor: Colors.white)),
                ),
                sizeW(15),
                Expanded(
                  child: simpleButton(
                      borderRadius: 20,
                      prefixIcon: Icon(
                        bookMarked.isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: Colors.white,
                      ),
                      prefixIconGap: 5,
                      height: 50,
                      onTap: () async {
                        bookMarked.isBookmarked
                            ? ref
                                .read(getAllBookmarkedProductsProvider.notifier)
                                .deleteBookmarkProduct(ref, product)
                            : ref
                                .read(getAllBookmarkedProductsProvider.notifier)
                                .addBookmarkProduct(ref, product);
                      },
                      title: text(
                          text: "Bookmark",
                          fontSize: 16,
                          textColor: Colors.white)),
                )
              ],
            ),
            sizeH(30),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    enableDrag: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(0))),
                    context: context,
                    builder: (context) => Container(
                          height: getScreenHeight(context),
                          padding: const EdgeInsets.all(16),
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
                                  text(
                                      text: "About product",
                                      fontSize: 18,
                                      fontWeight: 5),
                                ],
                              ),
                              sizeH25(),
                              text(text: product.description, fontSize: 16),
                            ],
                          ),
                        ));
              },
              borderRadius: radius(10),
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 5),
                height: 50,
                width: getScreenWidth(context),
                child: Row(
                  children: [
                    sizeW10(),
                    const Icon(
                      Icons.article_outlined,
                      color: Colors.green,
                      size: 26,
                    ),
                    sizeW25(),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(
                                  text: "Product Information",
                                  fontSize: 16,
                                  fontWeight: 5),
                              text(
                                  text: "Get full information about item",
                                  fontSize: 14),
                            ],
                          ),
                          const Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: Colors.green,
                            size: 28,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            sizeH(40),
            text(text: "Similar Products", fontSize: 18, fontWeight: 5),
            sizeH25(),
            getSimilarProducts.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(
                      child: Text("There is no product to show",
                          style: TextStyle(fontSize: 18)));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return products[index].id == product.id
                        ? Container()
                        : ProductContainer(ref: ref, product: products[index]);
                  },
                );
              },
              loading: () => Container(),
              error: (error, stack) {
                // Handle the error state
                return Center(
                    child: text(
                        text: "There is no product to show", fontSize: 18));
              },
            ),
            sizeH25(),
          ],
        ),
      )),
    );
  }
}
