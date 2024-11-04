import 'package:flutter/material.dart';
import '../../Package/PackageConstants.dart';
import '../../Package/Text_Button.dart';
import '../../Package/Utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/home_provider.dart';
import '../Utils/Widgets/ProductContainer.dart';
import '../Utils/Widgets/ProductShimmerContainer.dart';

class HomeScreen extends ConsumerWidget with text_with_button, utils {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productList = ref.watch(productsProvider);
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
