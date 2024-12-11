import 'package:flutter/material.dart';
import 'package:sle_buyer/Screen/bookmarked_product_screen.dart';
import '../../Package/PackageConstants.dart';
import '../../Package/RippleEffect/RippleEffectContainer.dart';
import '../../Package/Text_Button.dart';
import '../../Package/Utils.dart';
import '../../Screen/Auth/auth_screen.dart';
import '../../Screen/edit_profile_screen.dart';
import '../../provider/Auth/signup_provider.dart';
import '../../provider/dashboard_provider.dart';
import '../../provider/shared_preference.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/Auth/auth_provider.dart';

class ProfileScreen extends ConsumerWidget with text_with_button, utils {
  ProfileScreen({super.key});
  SharedPreference pref = SharedPreference();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        onChangeDashboardProvider(ref, 0);
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: CP(
              h: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizeH(40),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    width: getScreenWidth(context),
                    decoration: BoxDecoration(
                        color: Colors.green[100], borderRadius: radius(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: ClipRRect(
                                borderRadius: radius(80),
                                child: Image.network(
                                    pref.image_url == ""
                                        ? "Loading..."
                                        : pref.image_url,
                                    height: 80,
                                    errorBuilder: (context, error, stackTrace) {
                                  return SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: Center(
                                        child: text(
                                            text: "No Image", fontSize: 14)),
                                  );
                                }),
                              ),
                            ),
                            sizeW(15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                text(
                                  text: "${pref.first_name} ${pref.last_name}",
                                  fontSize: 18,
                                  fontWeight: 5,
                                ),
                                overFlowText(
                                    h: 20,
                                    w: getScreenWidth(context) * .5,
                                    text: pref.phone,
                                    fontSize: 14,
                                    fontWeight: 5,
                                    overflow: TextOverflow.ellipsis),
                                overFlowText(
                                    h: 20,
                                    w: getScreenWidth(context) * .5,
                                    text: pref.email,
                                    fontSize: 14,
                                    fontWeight: 5,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  sizeH(30),
                  text(
                    text: "Account Settings",
                    fontSize: 24,
                    fontWeight: 7,
                  ),
                  sizeH(30),
                  AccounttList(
                      onTap: () {
                        Navigation.pushMaterial(EditProfile(
                          first_name: pref.first_name,
                          last_name: pref.last_name,
                          company_address: pref.address,
                          company_description: "description",
                          phone: pref.phone,
                        ));
                      },
                      icon: Icons.person,
                      title: "My Profile",
                      subtitle: "Edit your personal information"),
                  AccounttList(
                      onTap: () {
                        Navigation.pushMaterial(
                            const BookmarkedProductScreen());
                      },
                      icon: Icons.bookmark,
                      title: "Bookmark",
                      subtitle: "See your all bookmarked"),
                  AccounttList(
                      onTap: () {
                        toast("Notification featue will be soon");
                      },
                      icon: Icons.notifications,
                      title: "Notification",
                      subtitle: "Updates and much more"),
                  AccounttList(
                      onTap: () {
                        final Uri url = Uri.parse(
                            "https://seamless-linkage-for-enterprises.github.io/terms-and-conditons/");
                        launchURL(url);
                      },
                      icon: Icons.assignment,
                      title: "Terms and Conditions",
                      subtitle: "Read our terms and conditions"),
                  AccounttList(
                      onTap: () {
                        final Uri url =
                            Uri.parse("https://github.com/mananKoyawala");
                        launchURL(url);
                      },
                      icon: Icons.info,
                      title: "About me",
                      subtitle: "Get information about us & SLE"),
                  AccounttList(
                      onTap: () {
                        decisionDialog(
                            "Logout",
                            "Are you sure, You want to logout?",
                            "No",
                            "Yes", () {
                          Navigation.pop();
                        }, () {
                          _logoutDetails();
                          onChangeDashboardProvider(ref, 0);
                          changeIsLoginOpen(ref, true);
                          // ref.read(productsProvider.notifier).resetProducts();
                          ref.read(termsAndConditionProvider.notifier).state =
                              false;
                          Navigation.pushMaterialAndRemoveUntil(AuthScreen());
                        });
                      },
                      icon: Icons.logout,
                      title: "Logout",
                      subtitle: "Sign out of your accountt"),
                  sizeH(40)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  deleteAccount() async {}

  _logoutDetails() async {
    pref.resetAll();
    await pref.setIsLoggedIn(false);
    await pref.setBuyerData("", "", "", "", "", "", "", "");
  }
}

class AccounttList extends StatelessWidget with text_with_button, utils {
  const AccounttList(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.title,
      required this.subtitle});
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Margin(
      margin: const EdgeInsets.only(bottom: 20),
      child: ClickEffect(
          onTap: onTap,
          borderRadius: radius(10),
          child: CP(
            h: 5,
            v: 10,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.green[100],
                  child: Icon(icon, color: Colors.green, size: 24),
                ),
                sizeW(25),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(text: title, fontSize: 16, fontWeight: 5),
                          text(text: subtitle, fontSize: 14),
                        ],
                      ),
                      const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.green,
                        size: 32,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
