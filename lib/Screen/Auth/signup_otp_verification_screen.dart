import 'package:flutter/material.dart';
import 'package:sle_buyer/provider/Auth/signup_provider.dart';
import '../../Package/PackageConstants.dart';
import '../../Package/TextFormField.dart';
import '../../Package/Text_Button.dart';
import '../../Package/Utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupOtpVerificationScreen extends ConsumerWidget
    with text_with_button, formField, utils {
  SignupOtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctr = ref.read(signupControllerProvider);
    final isLoading = ref.watch(isLoadingSignupProvider);
    final imageUploading = ref.watch(isSignupImageUploadedProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: CP(
          h: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizeH(70),
              text(text: 'We sent you OTP on', fontSize: 18),
              text(
                  text: ctr.phoneCtr.text.replaceRange(2, 8, '******'),
                  fontSize: 16,
                  fontWeight: 5),
              sizeH25(),
              Form(
                key: ctr.formKey2,
                child: textFormField(
                  autofocus: true,
                  context: context,
                  funValidate: (val) => Validator.requiredOTP(val),
                  controller: ctr.otpCtr,
                  isborder: false,
                  maxLength: 6,
                  hintText: "Enter 6 digit otp here",
                  textInputType: TextInputType.number,
                  fieldColor: Colors.green,
                  textInputAction: TextInputAction.done,
                  onClickColor: Colors.green,
                ),
              ),
              sizeH(60),
              simpleButton(
                  onTap: () async {
                    ctr.onSubmit2(ref);
                  },
                  title: text(
                    text: isLoading
                        ? "Verifying..."
                        : imageUploading
                            ? 'Image being uploaded...'
                            : "Submit",
                    fontSize: 18,
                    fontWeight: 5,
                    textColor: Colors.white,
                  ),
                  backgroundColor: Colors.green),
              sizeH(16)
            ],
          ),
        ),
      ),
    );
  }
}
