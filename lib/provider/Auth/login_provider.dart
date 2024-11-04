import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sle_buyer/Package/PackageConstants.dart';
import 'package:sle_buyer/helper/buyer_api_helper.dart';
import '../../Screen/Auth/login_otp_verification_screen.dart';

class LoginController {
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final phoneCtr = TextEditingController();
  final otpCtr = TextEditingController();
  bool onClicked = false; // to prevent from multiple clicks
  // Dispose method to be called when this controller is no longer needed
  void resetAll() {
    phoneCtr.clear();
    otpCtr.clear();
  }

  final apiHelper = BuyerApiHelper();

  void onSubmit1(WidgetRef ref) async {
    if (formKey1.currentState!.validate() && !onClicked) {
      onClicked = true;
      changeIsLoading(ref, true);
      bool isExists = await apiHelper.isBuyerExists(phoneCtr.text);

      if (isExists) {
        Navigation.pushMaterial(LoginOtpVerificationScreen());
      } else {
        toast("Can't find account with Phone number");
      }
      changeIsLoading(ref, false);
      onClicked = false;
    }
  }

  void onSubmit2(WidgetRef ref) async {
    if (formKey2.currentState!.validate() && !onClicked) {
      onClicked = true;
      changeIsLoading(ref, true);
      // calling buyer login
      bool isLoggedIn = await apiHelper.buyerLogin(phoneCtr.text);
      if (!isLoggedIn) {
        Navigation.pop();
      }
      changeIsLoading(ref, false);
      onClicked = false;
      await Future.delayed(const Duration(milliseconds: 300));
      resetAll();
    }
  }
}

// gives a riverpod instance of logincontroller
final loginControllerProvider = Provider((ref) => LoginController());

final isLoadingProvider = StateProvider<bool>((ref) => false);

void changeIsLoading(WidgetRef ref, bool val) {
  ref.read(isLoadingProvider.notifier).state = val;
}
