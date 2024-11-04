import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  bool isLoggedIn = false;
  String id = "";
  String first_name = "";
  String last_name = "";
  String email = "";
  String phone = "";
  String image_url = "";
  String address = "";
  String dob = "";

  static final SharedPreference _instance = SharedPreference.internal();
  factory SharedPreference() {
    return _instance;
  }
  SharedPreference.internal();

  Future<void> get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getInt('isLoggedIn') as bool;
    isLoggedIn ? isLoggedIn = true : isLoggedIn = false;
  }

  // save seller details after login or singup
  Future<void> setBuyerData(String id, first_name, last_name, email, phone,
      imageUrl, dob, address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id);
    await prefs.setString('first_name', first_name);
    await prefs.setString('last_name', last_name);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('image_url', imageUrl);
    await prefs.setString('dob', dob);
    await prefs.setString('address', address);
  }

  // retriving buyer data
  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    first_name = prefs.getString('first_name') ?? '';
    last_name = prefs.getString('last_name') ?? '';
    email = prefs.getString('email') ?? '';
    phone = prefs.getString('phone') ?? '';
    image_url = prefs.getString('image_url') ?? '';
    address = prefs.getString('address') ?? '';
    dob = prefs.getString('dob') ?? '';
  }

  // get user email
  Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? '';
  }

  // set seller login status
  Future<void> setIsLoggedIn(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', val);
  }

  // get seller login status
  Future<bool> getIsLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  void resetAll() {
    id = "";
    first_name = "";
    last_name = "";
    email = "";
    phone = "";
    image_url = "";
    address = "";
    dob = "";
  }

  // after update the seller data
  // Future<void> setOnlyData(String first_name, last_name, gender, dob) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('first_name', first_name);
  //   await prefs.setString('last_name', last_name);
  //   await prefs.setString('phone', gender);
  //   await prefs.setString('u_dob', dob);
  // }
}
