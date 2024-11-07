import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sle_buyer/Package/PackageConstants.dart';
import 'package:sle_buyer/helper/Firebase/firebase.dart';
import 'package:sle_buyer/helper/buyer_api_helper.dart';
import '../../Screen/Auth/login_otp_verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController with firebase {
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final phoneCtr = TextEditingController();
  final otpCtr = TextEditingController();
  String verificationId = "";
  bool isVerified = false;
  bool onClicked = false; // to prevent from multiple clicks
  // Dispose method to be called when this controller is no longer needed
  void resetAll() {
    verificationId = "";
    phoneCtr.clear();
    otpCtr.clear();
  }

  final apiHelper = BuyerApiHelper();

  void onSubmit1(WidgetRef ref) async {
    if (formKey1.currentState!.validate() && !onClicked) {
      onClicked = true;
      changeIsLoading(ref, true);

      // check user exists with phone number
      bool isExists = await apiHelper.isBuyerExists(phoneCtr.text);

      if (isExists) {
        // sending to otp verification screen
        verifyPhoneNumber();
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
      // verify otp
      isVerified = await verifyOTP();

      // if verified then proceed
      if (isVerified) {
        // if loggedIn true then it will be on home page
        bool isLoggedIn = await apiHelper.buyerLogin(phoneCtr.text);
        if (!isLoggedIn) {
          Navigation.pop();
        }
        printDebug(">>>debug1");
      }
      changeIsLoading(ref, false);
      onClicked = false;
      printDebug(">>>debug2");
    }
    if (isVerified) {
      printDebug(">>>debug3");
      await Future.delayed(const Duration(milliseconds: 150));
      resetAll();
      printDebug(">>>debug4");
    }
  }

  void verifyPhoneNumber() {
    auth
        .verifyPhoneNumber(
      phoneNumber: '+91${phoneCtr.text}',
      verificationCompleted: (e) {},
      verificationFailed: (e) {},
      codeSent: (id, token) {
        verificationId = id;
      },
      codeAutoRetrievalTimeout: (e) {},
    )
        .then((v) {
      // if otp send successfully then move to otp verification screen
      Navigation.pushMaterial(LoginOtpVerificationScreen());
    });
  }

  Future<bool> verifyOTP() async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpCtr.text,
    );
    bool isVerified = false;
    try {
      // validating user otp
      await auth.signInWithCredential(credential).then((v) {
        isVerified = true;
      });
    } catch (e) {
      toast("wrong otp");
      isVerified = false;
    }
    return isVerified;
  }
}

// gives a riverpod instance of logincontroller
final loginControllerProvider = Provider((ref) => LoginController());

final isLoadingProvider = StateProvider<bool>((ref) => false);

void changeIsLoading(WidgetRef ref, bool val) {
  ref.read(isLoadingProvider.notifier).state = val;
}
