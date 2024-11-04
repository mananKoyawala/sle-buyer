import 'package:flutter/material.dart';
import '../../Package/PackageConstants.dart';
import '../../Package/TextFormField.dart';
import '../../Package/Text_Button.dart';
import '../../Package/Utils.dart';
import '../../provider/Auth/login_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Login extends ConsumerWidget with text_with_button, formField, utils {
  Login({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctr = ref.read(loginControllerProvider);
    final isLoading = ref.watch(isLoadingProvider);
    return Column(
      children: [
        Form(
          key: ctr.formKey1,
          child: Column(
            children: [
              textFormField(
                context: context,
                funValidate: (val) => Validator.validatePhoneNumber(val),
                controller: ctr.phoneCtr,
                maxLength: 10,
                isborder: true,
                hintText: "Phone number",
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.done,
                fieldColor: Colors.green,
                onClickColor: Colors.green,
              ),
            ],
          ),
        ),
        sizeH(60),
        simpleButton(
            onTap: () async {
              ctr.onSubmit1(ref);
            },
            title: text(
              text: isLoading ? "Processing..." : "NEXT",
              fontSize: 18,
              fontWeight: 5,
              textColor: Colors.white,
            ),
            backgroundColor: Colors.green),
        sizeH(16)
      ],
    );
  }
}
