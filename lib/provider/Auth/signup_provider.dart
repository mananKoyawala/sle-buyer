import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sle_buyer/Screen/Auth/signup_otp_verification_screen.dart';
import 'package:sle_buyer/Screen/dashboard.dart';
import 'package:sle_buyer/helper/Firebase/firebase.dart';
import 'package:sle_buyer/helper/buyer_api_helper.dart';

import '../../Package/PackageConstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignupController with firebase {
  bool onClicked = false; // to prevent from multiple clicks
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  String verificationId = "";
  bool isSignedup = false;

  final firstNameCtr = TextEditingController();
  final lastNameCtr = TextEditingController();
  final emailCtr = TextEditingController();
  final phoneCtr = TextEditingController();
  final addressCtr = TextEditingController();
  final otpCtr = TextEditingController();
  final dateCtr = TextEditingController();
  File? image;
  String image_url = "";

  // called when controller no longer neeed
  void resetAll() {
    verificationId = "";
    firstNameCtr.clear();
    lastNameCtr.clear();
    emailCtr.clear();
    phoneCtr.clear();
    addressCtr.clear();
    otpCtr.clear();
    dateCtr.clear();
    image = null;
    image_url = "";
  }

  void onSubmit1(WidgetRef ref) async {
    var isTermsAccepted = ref.watch(termsAndConditionProvider);

    if (formKey1.currentState!.validate() && !onClicked) {
      // check image picked
      if (image == null) {
        toast("Please select image");
        return;
      }

      // check terms and conditions are accepted or not
      if (!isTermsAccepted) {
        toast("Please accept Terms and Conditons!");
        return;
      }
      onClicked = true;
      changeIsLoadingSingup(ref, true);

      // check user already exists wtih phone number
      final apiHelper = BuyerApiHelper();
      bool isExists = await apiHelper.isBuyerExists(phoneCtr.text);
      if (!isExists) {
        // verify user phone number
        verifyPhoneNumber();
      } else {
        toast("User already exist with Phone number");
      }
      changeIsLoadingSingup(ref, false);
      onClicked = false;
    }
  }

  void onSubmit2(WidgetRef ref) async {
    if (formKey2.currentState!.validate() && !onClicked) {
      onClicked = true;
      changeIsLoadingSingup(ref, true);

      // verify otp
      bool isVerified = await verifyOTP();
      changeIsLoadingSingup(ref, false);
      // otp wrong then return
      if (!isVerified) {
        onClicked = false;
        return;
      }

      //  add image to firebase
      changeSignupImageUploaded(ref, true);
      bool isImageUploaded = await _uploadImage();
      if (!isImageUploaded) {
        toast("Failed to upload image");
        onClicked = false;
        changeSignupImageUploaded(ref, false);
        return;
      }
      changeSignupImageUploaded(ref, false);
      changeIsLoadingSingup(ref, true);

      //  if image is added then add all details in database
      if (isVerified) {
        final apiHelper = BuyerApiHelper();
        isSignedup = await apiHelper.buyerSignup(
            firstNameCtr.text,
            lastNameCtr.text,
            emailCtr.text.toLowerCase(),
            image_url,
            addressCtr.text,
            phoneCtr.text,
            dateCtr.text);
        if (isSignedup) {
          // move to home page
          Navigation.pushMaterialAndRemoveUntil(Dashboard());
        }
      }
      changeIsLoadingSingup(ref, false);
      onClicked = false;
    }
    // reset all controller with caution
    if (isSignedup) {
      await Future.delayed(const Duration(milliseconds: 600));
      resetAll();
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

  changeDate(String val) {
    dateCtr.text = val;
  }

  Future<bool> _uploadImage() async {
    if (image == null) return false;

    try {
      // Define a unique path for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('sle/buyer/$fileName');

      // Upload the file
      await firebaseStorageRef.putFile(image!);

      // Get the download URL
      image_url = await firebaseStorageRef.getDownloadURL();
      printDebug(">>>Image uploaded successfully. Download URL: $image_url");
      return true;
    } catch (e) {
      printDebug(">>>Error uploading image: $e");
      return false;
    }
  }
}

final signupControllerProvider = Provider((ref) => SignupController());

// check the terms and conditons
final termsAndConditionProvider = StateProvider<bool>((ref) => false);

void changeTermsAndCondition(WidgetRef ref) {
  ref.read(termsAndConditionProvider.notifier).state =
      !ref.read(termsAndConditionProvider);
}

// to show progressing
final isLoadingSignupProvider = StateProvider<bool>((ref) => false);

void changeIsLoadingSingup(WidgetRef ref, bool val) {
  ref.read(isLoadingSignupProvider.notifier).state = val;
}

// to show image being uploaded
final isSignupImageUploadedProvider = StateProvider<bool>((ref) => false);

void changeSignupImageUploaded(WidgetRef ref, bool val) {
  ref.read(isSignupImageUploadedProvider.notifier).state = val;
}
