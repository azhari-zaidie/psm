import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psm_v2/user/authentication/user_login_screen.dart';
import 'package:psm_v2/user/profile/change_password_screen.dart';
import 'package:psm_v2/user/profile/update_profile_screen.dart';
import 'package:psm_v2/user/userPreferences/current_user.dart';
import 'package:psm_v2/user/userPreferences/user_preferences.dart';

class ProfileFragmentScreen extends StatelessWidget {
  ProfileFragmentScreen({super.key});
  final CurrentUser _currentUser = Get.put(CurrentUser());

  //getUserDetails() async {}
  signOutUser() async {
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey,
        title: const Text(
          "Log out",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure want to Log Out?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "No",
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: "LoggedOut");
            },
            child: const Text(
              "Yes",
            ),
          ),
        ],
      ),
    );

    if (resultResponse == "LoggedOut") {
      RememberUserPref.removeUserInfo()
          .then((value) => Get.to(const UserLoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          Center(
            child: Image.asset(
              "images/profile_icon.png",
              width: 240,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          userProfileDisplay(Icons.person, _currentUser.user.user_name),
          const SizedBox(
            height: 20,
          ),
          userProfileDisplay(Icons.person, _currentUser.user.user_email),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: () {
                    signOutUser();
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 40,
                    ),
                    child: Text(
                      "Sign Out",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text("Uji Makro Header"),
            ),
            ListTile(
              leading: const Icon(
                Icons.people,
              ),
              title: Text("Update Profile"),
              onTap: () {
                Get.to(UpdateProfileScreen());
              },
            ),
            const Divider(
              thickness: 5,
            ),
            ListTile(
              leading: const Icon(
                Icons.lock,
              ),
              title: const Text("Change Password"),
              onTap: () {
                Get.to(ChangePasswordScreen());
              },
            ),
            const Divider(
              thickness: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget userProfileDisplay(IconData iconData, String userData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black87,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color: Colors.white,
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            userData,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
