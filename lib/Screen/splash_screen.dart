import 'package:flutter/material.dart';
import 'package:sle_buyer/Package/PackageConstants.dart';
import 'package:sle_buyer/Package/Text_Button.dart';
import 'package:sle_buyer/Package/Utils.dart';
import 'package:sle_buyer/Screen/dashboard.dart';
import 'package:sle_buyer/provider/shared_preference.dart';
import 'package:sle_buyer/connection/connectivity_helper.dart';
import '../Service/NavigatorKey.dart';
import '../Utils/Widgets/no_internet.dart';
import 'Auth/auth_screen.dart';

class SplashScreen extends StatelessWidget with text_with_button, utils {
  const SplashScreen({super.key});

  void _navigateAfterDelay() async {
    // check internet connection
    final hasInternetConnection =
        await ConnectivityHelper.hasInternetConnection();
    if (!hasInternetConnection) {
      showNoInternetDialog(
          context: navigatorContext,
          onPressed: () {
            Navigation.pop();
            _navigateAfterDelay();
          });
      return;
    }

    await Future.delayed(const Duration(milliseconds: 1500));
    SharedPreference pref = SharedPreference();
    bool isLoggedIn = await pref.getIsLoggedIn();

    isLoggedIn
        ? Navigation.pushMaterialAndRemoveUntil(Dashboard())
        : Navigation.pushMaterialAndRemoveUntil(AuthScreen());
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateAfterDelay();
    });
    return Scaffold(
      body: Center(
          child: text(
              text: "Splash Screen",
              fontSize: 55,
              fontFamily: "great-vibes",
              textColor: Colors.green)),
    );
  }
}
