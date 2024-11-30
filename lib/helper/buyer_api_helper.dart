import 'dart:convert';
import '../../Screen/dashboard.dart';
import '../../provider/Auth/signup_provider.dart';
import '../../provider/shared_preference.dart';

import '../Package/PackageConstants.dart';
import '../Utils/constants.dart';
import '../api/api_service.dart';
import '../models/buyer.dart';

class BuyerApiHelper {
  SharedPreference pref = SharedPreference();
  final apiService = ApiService();
  SignupController signupController = SignupController();

  Future<bool> buyerLogin(String phone) async {
    var response = await apiService.performRequest(
      method: 'POST',
      endpoint: '/buyers/login',
      body: {'b_phone': phone, 'b_password': "Admin@123"},
      // here password is not required but provided beacuse of backend misconfigurations
    );

    try {
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final data = responseBody['data'] ?? 'null';
        Buyer buyer = Buyer.fromJson(data);
        // add data in shareprefernce
        pref.setIsLoggedIn(true);
        pref.setBuyerData(
            buyer.id,
            buyer.first_name,
            buyer.last_name,
            buyer.email,
            buyer.phone,
            buyer.image_url,
            buyer.dob,
            buyer.address);
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
    } catch (e) {
      printDebug("Error during buyer login: $e");
      showSomeThingWrongSnackBar();
      return false;
    }
  }

  Future<bool> isBuyerExists(String phone) async {
    var response = await apiService.performRequest(
        method: 'GET', endpoint: '/buyers/phone/$phone');

    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug("Error during is buyer exists: $e");
      showSomeThingWrongSnackBar();
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
    var response = await apiService.performRequest(
      method: 'POST',
      endpoint: '/buyers/signup',
      body: {
        'b_first_name': first_name,
        'b_last_name': last_name,
        'b_email': email,
        'b_password': "Admin@123",
        'b_image_url': image_url,
        'b_address': address,
        'b_phone': phone,
        'b_dob': dob,
      },
    );

    try {
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = responseBody['data'] ?? 'null';
        Buyer buyer = Buyer.fromJson(data);
        // add data in shareprefernce
        pref.setIsLoggedIn(true);
        pref.setBuyerData(
            buyer.id,
            buyer.first_name,
            buyer.last_name,
            buyer.email,
            buyer.phone,
            buyer.image_url,
            buyer.dob,
            buyer.address);
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
    } catch (e) {
      printDebug("Error during buyer signup: $e");
      showSomeThingWrongSnackBar();
      return false;
    }
  }
}
