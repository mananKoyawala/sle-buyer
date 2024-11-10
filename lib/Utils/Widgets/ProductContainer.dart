import 'package:sle_buyer/Screen/product_details_screen.dart';

import '../../Package/PackageConstants.dart';
import '../../Package/RippleEffect/RippleEffectContainer.dart';
import '../../Package/Text_Button.dart';
import '../../Package/Utils.dart';
import '../../helper/product_api_helper.dart';
import '../../models/Product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../provider/bookmarked_product_provider.dart';

class ProductContainer extends StatelessWidget with text_with_button, utils {
  ProductContainer({super.key, required this.product, required this.ref});
  final Product product;
  final WidgetRef ref;
  ProductApiHelper helper = ProductApiHelper();
  @override
  Widget build(BuildContext context) {
    return Margin(
      margin: const EdgeInsets.only(bottom: 20),
      child: ClickEffect(
        onTap: () {
          // show products details
          final notifier = ref.read(getAllBookmarkedProductsProvider.notifier);
          notifier.isProductBookmarked(product);
          Navigation.pushMaterial(ProductDetailsScreen(product: product));
        },
        borderRadius: radius(20),
        child: Container(
          height: 160,
          width: getScreenWidth(context),
          decoration:
              BoxDecoration(color: Colors.green[50], borderRadius: radius(20)),
          child: Row(
            children: [
              Container(
                width: getScreenWidth(context) * .35,
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: radius(20)),
                child: ClipRRect(
                  borderRadius: radius(20),
                  child: Image.network(
                    product.image_url,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                          child: text(text: "No Image", fontSize: 18));
                    },
                  ),
                ),
              ),
              sizeW10(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  sizeH10(),
                  overFlowText(
                      h: 20,
                      w: getScreenWidth(context) / 2,
                      text: product.name,
                      fontSize: 16,
                      fontWeight: 5,
                      overflow: TextOverflow.ellipsis),
                  sizeH(10),
                  overFlowText(
                      h: 20,
                      w: getScreenWidth(context) / 2,
                      maxLines: 1,
                      text: product.brand,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis),
                  sizeH(10),
                  text(
                      text: "₹${product.price} / piece",
                      fontSize: 16,
                      textColor: Colors.green),
                  sizeH(10),
                  simpleButton(
                      height: 40,
                      width: 100,
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
                          textColor: Colors.white))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
