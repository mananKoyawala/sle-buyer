import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sle_buyer/Package/PackageConstants.dart';

import '../Service/NavigatorKey.dart';
import '../Utils/Widgets/no_internet.dart';
import '../Utils/constants.dart';
import '../connection/connectivity_helper.dart';

class ApiService {
  final String baseURL = dotenv.env['API_URL'] ?? '';

  Future<http.Response> buyerLogin(String phone) async {
    return await http.post(
      Uri.parse('$baseURL/buyers/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {'b_phone': phone, 'b_password': "Admin@123"},
        // here password is not required but provided beacuse of backend misconfigurations
      ),
    );
  }

  Future<http.Response> buyerSignup(
    String first_name,
    last_name,
    email,
    image_url,
    address,
    phone,
    dob,
  ) async {
    return await http.post(
      Uri.parse('$baseURL/buyers/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          'b_first_name': first_name,
          'b_last_name': last_name,
          'b_email': email,
          'b_password': "Admin@123",
          'b_image_url': image_url,
          'b_address': address,
          'b_phone': phone,
          'b_dob': dob,
        },
      ),
    );
  }

  Future<http.Response> isBuyerExists(String phone) async {
    return await http.get(
      Uri.parse('$baseURL/buyers/phone/$phone'),
    );
  }

  // * common function that performs final api calls which handles connectivity checks and potential exceptions
  Future<http.Response> performRequest({
    required String method,
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Function? onNoInternet, // call back for handling no internet
  }) async {
    // * check here internet connectivity
    final hasInternet = await ConnectivityHelper.hasInternetConnection();
    printDebug(">>>*$hasInternet");
    if (!hasInternet) {
      if (onNoInternet != null) {
        onNoInternet();
      } else {
        showNoInternetDialog(context: navigatorContext);
      }
      return http.Response('{"error":"No Internet Connection"}', 503);
    }
    // * prepare request
    final uri = Uri.parse('$baseURL$endpoint');
    headers ??= {'Content-Type': 'application/json'};

    http.Response response =
        http.Response('{"error":"request is failed"}', 503);
    try {
      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: headers);
        case 'POST':
          response =
              await http.post(uri, headers: headers, body: jsonEncode(body));
        case 'PUT':
          response =
              await http.put(uri, headers: headers, body: jsonEncode(body));
        case 'PATCH':
          response =
              await http.patch(uri, headers: headers, body: jsonEncode(body));
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
        default:
          throw ('Unsupported HTTP method');
      }

      return response;
    } catch (e) {
      printDebug('>>>Error during API call: $e');
      showSomeThingWrongSnackBar();
      return response;
    }
  }
}
