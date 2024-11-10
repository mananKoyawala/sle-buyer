import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sle_buyer/Package/TextFormField.dart';
import 'package:sle_buyer/Screen/search_products.dart';
import '../../Package/PackageConstants.dart';
import '../../Package/Text_Button.dart';
import '../../Package/Utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/home_provider.dart';
import '../Utils/Widgets/ProductContainer.dart';
import '../Utils/Widgets/ProductShimmerContainer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../provider/bookmarked_product_provider.dart';

class HomeScreen extends ConsumerWidget
    with text_with_button, formField, utils {
  HomeScreen({super.key});
  TextEditingController searchTextField = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productList = ref.watch(productsProvider);
    ref.watch(
        getAllBookmarkedProductsProvider); // get bookmarked products in advance

    return SafeArea(
      child: Scaffold(
        body: CP(
            h: 16,
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizeH(50),
                    text(text: "Your Products", fontSize: 22, fontWeight: 5),
                    sizeH25(),
                    textFormField(
                        context: context,
                        funValidate: (val) => null,
                        borderRadius: 30,
                        readOnly: true,
                        onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              enableDrag: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(0))),
                              context: context,
                              builder: (context) => Container(
                                    height: getScreenHeight(context),
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        sizeH(45),
                                        textFormField(
                                            onFieldSubmitted: (val) {
                                              Navigation.pop();
                                              Navigation.pushMaterial(
                                                  SearchResultScreen(
                                                      searchTextField.text));
                                              searchTextField.clear();
                                              return null;
                                            },
                                            autofocus: true,
                                            context: context,
                                            funValidate: (val) =>
                                                Validator.fieldRequired(val),
                                            borderRadius: 30,
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            prefixIcon: const Icon(
                                              Icons.search,
                                              color: Colors.green,
                                            ),
                                            hintText: "Search here...",
                                            controller: searchTextField,
                                            isborder: true,
                                            textInputType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.search,
                                            suffixIcon: iconButton(
                                              onTap: () {
                                                searchTextField.clear();
                                                Navigation.pop();
                                              },
                                              icon: const Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons
                                                      .xmark, // This is a simple cross icon
                                                  color: Colors.green,
                                                  size: 20,
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ));
                        },
                        contentPadding: const EdgeInsets.all(0),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.green,
                        ),
                        hintText: "Search here...",
                        isborder: true),
                    sizeH25(),
                    productList.isLoading
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return const ProductShimmerContainer();
                            })
                        : productList.products.isEmpty
                            ? SizedBox(
                                height: 250,
                                child: Center(
                                  child:
                                      text(text: "No Products", fontSize: 18),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: productList.products.length,
                                itemBuilder: (context, index) {
                                  return ProductContainer(
                                    ref: ref,
                                    product: productList.products[index],
                                  );
                                }),
                    sizeH(40),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
