import 'dart:convert';
import 'package:psm_v2/user/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPref {
  //this method to save user info in json format
  static Future<void> storeUserInfo(User userInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());

    await preferences.setString("currentUser", userJsonData);
  }

  //read the user info
  //get the data
  static Future<User?> readUserInfo() async {
    User? currentUserInfo;

    SharedPreferences preferences = await SharedPreferences.getInstance();

    String? userInfo = preferences.getString("currentUser");

    if (userInfo != null) {
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      currentUserInfo = User.fromJson(userDataMap);
    } else {
      // ignore: avoid_print
      print("No user info yet");
    }
    return currentUserInfo;
  }

  //remove session
  //remove user info from local storage
  static Future<void> removeUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("currentUser");
  }
}
