import 'package:flutter/services.dart';
import 'package:flutterproject/pages/dash_board_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterproject/pages/login_page.dart';
import 'package:flutterproject/pages/profile_creation_page.dart';
import 'package:flutter/foundation.dart';


class HttpRequest {
  // set up http client to able to send requests to endpoints
  static final httpClient = http.Client();
  static var loginEndPoint = Uri.parse('http://127.0.0.1:5000/login');
  static var signUpEndPoint = Uri.parse('http://127.0.0.1:5000/signup');
  static var quoteEndPoint = Uri.parse('http://127.0.0.1:5000/quote');

  static handleSignUp(username, password, email, context) async {
    //Change Local Host uri when running on an android device
    if (defaultTargetPlatform == TargetPlatform.android){
      signUpEndPoint = Uri.parse('http://10.0.2.2:5000/signup');
    }

    // send post request
    http.Response response = await httpClient.post(signUpEndPoint, body: {
      "username": username,
      "password": password,
      "email" : email,
    });

    // error occurs
    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    } else {
      // response received by endpoint
      print("Response received");
      print(jsonDecode(response.body));
      var json = jsonDecode(response.body);

      if (json[0] == 'Register success. Login now') {
        await EasyLoading.showSuccess(json[0]);

        await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        EasyLoading.showError(json[0]);

      }

    }

  }


  static handleLogin(username, password, context) async {
    // send post request
    http.Response response = await httpClient.post(loginEndPoint, body: {
      "username": username,
      "password": password,
    });
    print(response);

    // error occurs
    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    } else {
      // response received by endpoint
      print(jsonDecode(response.body));
      var json = jsonDecode(response.body);

      if (json[0] == 'success') {
        await EasyLoading.showSuccess(json[0]);
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileCreation()));
      } else {
        EasyLoading.showError(json[0]);
      }


    }

  }
//  userName,

  static handleQuotePost(userId, gallons, address, date, suggested, total, context) async {
    //Change Local Host uri when running on an android device
    if (defaultTargetPlatform == TargetPlatform.android){
      quoteEndPoint = Uri.parse('http://10.0.2.2:5000/quote');
    }

    // send post request
    http.Response response = await httpClient.post(quoteEndPoint, body: {
      "user_id": userId,
      "gallons": gallons,
      "address" : address,
      "date" : date,
      "suggested" : suggested,
      "total" : total,
    });

    // error occurs
    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    } else {
      // response received by endpoint
      var json = jsonDecode(response.body);

      if (json[0] == 'Fuel Quote created') {
        await EasyLoading.showSuccess(json[0]);

        await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
      } else {
        EasyLoading.showError(json[0]);
        print(json[0]);

      }

    }

  }

}