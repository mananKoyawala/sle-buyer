import '../Service/NavigatorKey.dart';
import 'package:flutter/material.dart';

void showSomeThingWrongSnackBar() {
  ScaffoldMessenger.of(navigatorContext).showSnackBar(const SnackBar(
    content: Text("Something went wrong, please try again later."),
  ));
}
