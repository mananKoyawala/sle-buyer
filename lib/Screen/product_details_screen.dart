import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sle_buyer/Package/PackageConstants.dart';
import 'package:sle_buyer/Package/Text_Button.dart';
import 'package:sle_buyer/Package/Utils.dart';
import 'package:sle_buyer/models/Product.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsScreen extends StatelessWidget
    with text_with_button, utils {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          sizeH(45),
          text(
              text: "Product Details",
              fontSize: 26,
              textAlign: TextAlign.center,
              fontWeight: 5),
          sizeH10(),
          Expanded(
              child: CP(
            h: 16,
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
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
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                            child: text(text: "No Image", fontSize: 18));
                      },
                    ),
                  ),
                ),
                sizeH25(),
                overFlowText(
                    h: 20,
                    w: getScreenWidth(context),
                    text: product.name,
                    fontSize: 18,
                    fontWeight: 7),
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
                          prefixIcon: const Icon(
                            Icons.bookmark_border,
                            color: Colors.white,
                          ),
                          prefixIconGap: 5,
                          height: 50,
                          onTap: () {},
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
                text(text: "Similar Products", fontSize: 18, fontWeight: 5)
              ],
            ),
          ))
        ],
      ),
    );
  }
}
