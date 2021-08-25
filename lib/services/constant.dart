import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  // static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";

  // static Future<bool> saveUserLoggedInSharedPreference(
  //     bool isUserLoggedIn) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   return await preferences.setBool(
  //       Constants.sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  // }

  // static Future<bool> getUerLoggedInSharedPreference() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   return sharedPreferences.get(Constants.sharedPreferenceUserLoggedInKey);
  // }

  static BoxShadow myBoxShadow() {
    return BoxShadow(
      color: Colors.black54,
      blurRadius: 1.0,
      spreadRadius: 2.0,
      offset: Offset(2, 2),
    );
  }

  static Color primaryColor() {
    return Colors.deepPurple;
  }
}
