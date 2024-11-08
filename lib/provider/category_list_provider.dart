import 'package:flutter/material.dart';

import '../Package/PackageConstants.dart';
import '../helper/product_api_helper.dart';
import '../models/Product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// categories = [
//     "Footwear",
//     "Grocery",
//     "Food & Beverages",
//     "Electronics",
//     "Home & Kitchen",
//     "Fashion & Clothing",
//     "Health & Beauty",
//     "Sports & Outdoors",
//     "Toys & Games",
//     "Books & Stationery",
//     "Automotive",
//     "Furniture",
//     "Jewelry & Accessories",
//     "Baby & Kids",
//     "Pet Supplies",
//     "Office Supplies",
//     "Travel & Luggage",
//     "Musical Instruments",
//     "Gardening",
//     "Hardware & Tools",
//     "Art & Craft",
//     "Software & Apps",
//     "Smartphones & Tablets",
//     "Computers & Laptops",
//     "Cameras & Photography",
//     "Gaming",
//     "Hobbies & Collections",
//     "Industrial Supplies",
//   ];

class CategoryState {
  final List<Product> products;
  final bool isLoading;

  CategoryState({
    required this.products,
    required this.isLoading,
  });
}

// Update ProductNotifier to use ProductState
class CategoryNotifier extends AutoDisposeNotifier<CategoryState> {
  final ProductApiHelper helper;

  CategoryNotifier() : helper = ProductApiHelper();

  @override
  CategoryState build() {
    printDebug(">>>passed");
    state = CategoryState(
      products: [],
      isLoading: true,
    );
    return state;
  }

  static const List<String> categories = [
    "Footwear",
    "Grocery",
    "Food & Beverages",
    "Electronics",
    "Home & Kitchen",
    "Fashion & Clothing",
    "Health & Beauty",
    "Sports & Outdoors",
    "Toys & Games",
    "Books & Stationery",
    "Automotive",
    "Furniture",
    "Jewelry & Accessories",
    "Baby & Kids",
    "Pet Supplies",
    "Office Supplies",
    "Travel & Luggage",
    "Musical Instruments",
    "Gardening",
    "Hardware & Tools",
    "Art & Craft",
    "Software & Apps",
    "Smartphones & Tablets",
    "Computers & Laptops",
    "Cameras & Photography",
    "Gaming",
    "Hobbies & Collections",
    "Industrial & Equipments",
  ];

  static const List<IconData> categoryIcons = [
    Icons.directions_walk, // Footwear
    Icons.local_grocery_store, // Grocery
    Icons.restaurant_menu, // Food & Beverages
    Icons.devices, // Electronics
    Icons.kitchen, // Home & Kitchen
    Icons.checkroom, // Fashion & Clothing
    Icons.health_and_safety, // Health & Beauty
    Icons.sports, // Sports & Outdoors
    Icons.toys, // Toys & Games
    Icons.menu_book, // Books & Stationery
    Icons.directions_car, // Automotive
    Icons.chair, // Furniture
    Icons.diamond, // Jewelry & Accessories
    Icons.child_friendly, // Baby & Kids
    Icons.pets, // Pet Supplies
    Icons.business, // Office Supplies
    Icons.card_travel, // Travel & Luggage
    Icons.music_note, // Musical Instruments
    Icons.grass, // Gardening
    Icons.build, // Hardware & Tools
    Icons.brush, // Art & Craft
    Icons.apps, // Software & Apps
    Icons.smartphone, // Smartphones & Tablets
    Icons.computer, // Computers & Laptops
    Icons.camera_alt, // Cameras & Photography
    Icons.videogame_asset, // Gaming
    Icons.palette, // Hobbies & Collections
    Icons.factory, // Industrial & Equipments
  ];
}

final categoryProvider =
    NotifierProvider.autoDispose<CategoryNotifier, CategoryState>(
        () => CategoryNotifier());
