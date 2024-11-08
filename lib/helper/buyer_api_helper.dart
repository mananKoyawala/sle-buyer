import 'dart:convert';
import '../../Screen/dashboard.dart';
import '../../provider/Auth/signup_provider.dart';
import '../../provider/shared_preference.dart';

import '../Package/PackageConstants.dart';
import '../api/api_service.dart';
import '../models/buyer.dart';

class BuyerApiHelper {
  SharedPreference pref = SharedPreference();
  final apiService = ApiService();
  SignupController signupController = SignupController();

  Future<bool> buyerLogin(String phone) async {
    var response = await apiService.buyerLogin(phone);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final data = responseBody['data'] ?? 'null';
      Buyer buyer = Buyer.fromJson(data);
      // add data in shareprefernce
      pref.setIsLoggedIn(true);
      pref.setBuyerData(buyer.id, buyer.first_name, buyer.last_name,
          buyer.email, buyer.phone, buyer.image_url, buyer.dob, buyer.address);
      await pref.getUserData();
      await Future.delayed(const Duration(milliseconds: 150));
      toast("User login successful.");
      return true;
    } else {
      final responseBody = jsonDecode(response.body);
      final data = responseBody['error'] ?? 'Failed to login';
      printDebug(">>>$data");
      toast("Can't find account with Phone number");
      return false;
    }
  }

  Future<bool> isBuyerExists(String phone) async {
    var response = await apiService.isBuyerExists(phone);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> buyerSignup(
    String first_name,
    last_name,
    email,
    image_url,
    address,
    phone,
    dob,
  ) async {
    var response = await apiService.buyerSignup(
      first_name,
      last_name,
      email,
      image_url,
      address,
      phone,
      dob,
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final data = responseBody['data'] ?? 'null';
      Buyer buyer = Buyer.fromJson(data);
      // add data in shareprefernce
      pref.setIsLoggedIn(true);
      pref.setBuyerData(buyer.id, buyer.first_name, buyer.last_name,
          buyer.email, buyer.phone, buyer.image_url, buyer.dob, buyer.address);
      await pref.getUserData();
      await Future.delayed(const Duration(milliseconds: 150));
      toast("Registration completed");
      Navigation.pushMaterialAndRemoveUntil(const Dashboard());
      return true;
    } else {
      final data = responseBody['error'] ?? 'Failed to register buyer';
      printDebug(">>>$data");
      if (data.toString().contains("duplicate key")) {
        toast("User already registred with Phone number");
        return false;
      }
      toast('Failed to register buyer');
      return false;
    }
  }
}
