import 'package:get/get.dart';
import 'package:psm_v2/user/model/user.dart';
import 'package:psm_v2/user/userPreferences/user_preferences.dart';

class CurrentUser extends GetxController {
  // ignore: prefer_final_fields
  Rx<User> _currentUser = User(0, '', '', '', '').obs;

  User get user => _currentUser.value;

  getUserInfo() async {
    User? getUserInfoFromLocalStorage = await RememberUserPref.readUserInfo();

    _currentUser.value = getUserInfoFromLocalStorage!;
  }
}
