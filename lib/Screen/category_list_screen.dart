import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sle_buyer/Package/Text_Button.dart';
import 'package:sle_buyer/Package/Utils.dart';
import 'package:sle_buyer/provider/category_list_provider.dart';
import 'package:sle_buyer/provider/show_category_provider.dart';

import '../Package/PackageConstants.dart';
import 'show_category_screen.dart';

class CategoryScreen extends ConsumerWidget with text_with_button, utils {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> categoriesList = CategoryNotifier.categories;
    List<IconData> iconsList = CategoryNotifier.categoryIcons;
    List<String> formattedCategoriesList = categoriesList
        .map((category) => category.replaceAll('&', '&\n'))
        .toList();
    return Scaffold(
        body: CP(
      h: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sizeH(40),
          text(text: "Categories", fontSize: 26, fontWeight: 5),
          sizeH(10),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(0),
              crossAxisCount: 3,
              children: List.generate(formattedCategoriesList.length, (index) {
                return Margin(
                  margin: const EdgeInsets.all(5),
                  child: InkWell(
                    onTap: () async {
                      // Call fetchData for the selected category
                      final selectedCategory = categoriesList[index];
                      // await ref
                      //     .read(showCategoryProductsProvider.notifier)
                      //     .fetchData("Electronics");

                      // Navigate to the HomeScreen or the screen that displays products
                      Navigation.pushMaterial(
                          ShowCategoryScreen(category: selectedCategory));
                    },
                    borderRadius: radius(10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green, borderRadius: radius(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            iconsList[index],
                            color: Colors.white,
                            size: 26,
                          ),
                          text(
                              text: formattedCategoriesList[index],
                              fontSize: 14,
                              textColor: Colors.white,
                              textAlign: TextAlign.center,
                              fontWeight: 5,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // sizeH25(),
        ],
      ),
    ));
  }
}
