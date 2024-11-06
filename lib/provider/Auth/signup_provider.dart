import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sle_buyer/Screen/Auth/signup_otp_verification_screen.dart';
import 'package:sle_buyer/Screen/dashboard.dart';
import 'package:sle_buyer/helper/Firebase/firebase.dart';
import 'package:sle_buyer/helper/buyer_api_helper.dart';

import '../../Package/PackageConstants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupController with firebase {
  bool onClicked = false; // to prevent from multiple clicks
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  String verificationId = "";

  final firstNameCtr = TextEditingController();
  final lastNameCtr = TextEditingController();
  final emailCtr = TextEditingController();
  final phoneCtr = TextEditingController();
  final addressCtr = TextEditingController();
  final otpCtr = TextEditingController();

  // called when controller no longer neeed
  void resetAll() {
    verificationId = "";
    firstNameCtr.clear();
    lastNameCtr.clear();
    emailCtr.clear();
    phoneCtr.clear();
    addressCtr.clear();
    otpCtr.clear();
  }

  void onSubmit1(WidgetRef ref) async {
    var isTermsAccepted = ref.watch(termsAndConditionProvider);

    if (formKey1.currentState!.validate() && !onClicked) {
      if (!isTermsAccepted) {
        toast("Please accept Terms and Conditons!");
        return;
      }
      onClicked = true;
      changeIsLoadingSingup(ref, true);

      final apiHelper = BuyerApiHelper();
      bool isExists = await apiHelper.isBuyerExists(phoneCtr.text);
      if (!isExists) {
        verifyPhoneNumber();
      } else {
        toast("User already exist with Phone number");
      }
      changeIsLoadingSingup(ref, false);
      onClicked = false;
    }
  }

  void onSubmit2(WidgetRef ref) async {
    var isTermsAccepted = ref.watch(termsAndConditionProvider);

    if (formKey2.currentState!.validate() && !onClicked) {
      if (!isTermsAccepted) {
        toast("Please accept Terms and Conditons!");
        return;
      }
      onClicked = true;
      changeIsLoadingSingup(ref, true);

// verify otp
      bool isVerified = await verifyOTP();

      //  call buyer api
      if (isVerified) {
        final apiHelper = BuyerApiHelper();
        bool isSignedup = await apiHelper.buyerSignup(
            firstNameCtr.text,
            lastNameCtr.text,
            emailCtr.text,
            "https://images.pexels.com/photos/1520760/pexels-photo-1520760.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
            addressCtr.text,
            phoneCtr.text,
            "2002-02-02");
        if (isSignedup) {
          Navigation.pushMaterial(Dashboard());
          await Future.delayed(const Duration(milliseconds: 600));
          resetAll();
        }
      }
      changeIsLoadingSingup(ref, false);
      onClicked = false;
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
      Navigation.pushMaterial(SignupOtpVerificationScreen());
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

final signupControllerProvider = Provider((ref) => SignupController());

// check the terms and conditons
final termsAndConditionProvider = StateProvider<bool>((ref) => false);

void changeTermsAndCondition(WidgetRef ref) {
  ref.read(termsAndConditionProvider.notifier).state =
      !ref.read(termsAndConditionProvider);
}

// obsecure text provider
final isLoadingSignupProvider = StateProvider<bool>((ref) => false);

void changeIsLoadingSingup(WidgetRef ref, bool val) {
  ref.read(isLoadingSignupProvider.notifier).state = val;
}
