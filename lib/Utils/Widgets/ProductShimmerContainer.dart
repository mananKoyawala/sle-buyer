import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sle_buyer/Package/Utils.dart';

class ProductShimmerContainer extends StatelessWidget with utils {
  const ProductShimmerContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200], // Light background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[400]!, // Darker base color for shimmer elements
        highlightColor: Colors.grey[300]!, // Slightly lighter highlight color
        child: Row(
          children: [
            // Image Placeholder
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Colors.grey[400], // Darker shimmer color for image
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(width: 10),
            // Text and Buttons Placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Product Name Placeholder
                  Container(
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.4,
                    color: Colors.grey[400],
                  ),
                  // Product Brand Placeholder
                  Container(
                    height: 14,
                    width: MediaQuery.of(context).size.width * 0.3,
                    color: Colors.grey[400],
                  ),
                  // Product Price Placeholder
                  Container(
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.25,
                    color: Colors.grey[400],
                  ),
                  // Buttons Row Placeholder
                  Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.grey[400], borderRadius: radius(10)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
