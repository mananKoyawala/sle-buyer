import '../../Package/PackageConstants.dart';
import '../../Package/RippleEffect/RippleEffectContainer.dart';
import '../../Package/Text_Button.dart';
import '../../Package/Utils.dart';
import '../../helper/product_api_helper.dart';
import '../../models/Product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        },
        borderRadius: radius(20),
        child: Container(
          height: 170,
          width: getScreenWidth(context),
          decoration:
              BoxDecoration(color: Colors.green[100], borderRadius: radius(20)),
          child: Row(
            children: [
              Container(
                width: getScreenWidth(context) * .35,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: radius(20)),
                child: ClipRRect(
                  borderRadius: radius(20),
                  child: Image.network(
                    product.image_url,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                          child: text(text: "No Image", fontSize: 16));
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
                  text(text: product.name, fontSize: 18, fontWeight: 5),
                  sizeH(5),
                  overFlowText(
                      h: 20,
                      w: getScreenWidth(context) / 2,
                      maxLines: 1,
                      text: product.brand,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis),
                  sizeH(10),
                  text(
                      text: "${product.price}₹ / Piece",
                      fontSize: 16,
                      textColor: Colors.green),
                  sizeH(10),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
