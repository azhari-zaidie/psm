import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:psm_v2/api_connection/api_connection_laravel.dart';
import 'package:psm_v2/user/fragment/dashboard_fragment_screen.dart';
//import 'package:psm_v2/user/fragment/home_fragment_screen.dart';
//import 'package:psm_v2/user/fragment/profile_fragment_screen.dart';
import 'package:psm_v2/user/model/user.dart';
import 'package:psm_v2/user/userPreferences/current_user.dart';
import 'package:http/http.dart' as http;
import 'package:psm_v2/user/userPreferences/user_preferences.dart';

class UpdateProfileScreen extends StatefulWidget {
  UpdateProfileScreen({super.key});
  final CurrentUser _currentUser = Get.put(CurrentUser());

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  //String _updatedName = '';
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget._currentUser.user.user_name;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  updateProfile() async {
    try {
      var res = await http.post(
        Uri.parse(APILARAVEL.updateProfile),
        body: jsonEncode(
          {
            'user_email': widget._currentUser.user.user_email,
            'user_name': nameController.text,
          },
        ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        var responseBodyOfUpdateProfile = jsonDecode(res.body);
        if (responseBodyOfUpdateProfile['success']) {
          //create variable to assign the userData that contain the details of user
          User userInfo =
              User.fromJson(responseBodyOfUpdateProfile["userData"]);
          //save userinfo to local storage
          await RememberUserPref.storeUserInfo(userInfo);
          Fluttertoast.showToast(
              msg: "Successfull updating profile. Refresh the page");
          Get.to(DasboardFragmentScreen());
        } else {
          //print("sinsss");
        }
      } else {
        Fluttertoast.showToast(msg: "Error. Something wrong");
        print("status code not 200 for updating profile");
      }
    } catch (e) {
      print("Error :: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 99, 0, 238),
        title: const Text(
          "Profile Update",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          Form(
            key: formKey,
            child: Column(
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

                //email
                TextFormField(
                  enabled: false,
                  initialValue: widget._currentUser.user.user_email,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  //controller: nameController,
                  validator: (value) =>
                      value == "" ? "Please write name" : null,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.black,
                      size: 30,
                    ),
                    hintText: widget._currentUser.user.user_email,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                //name
                TextFormField(
                  controller: nameController,
                  validator: (value) => value == "" || value!.isEmpty
                      ? "Please enter name"
                      : null,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.people,
                      color: Colors.black,
                      size: 30,
                    ),

                    //hintText: widget._currentUser.user.user_name,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: () async {
                    var responseOfDialogBox = await Get.dialog(
                      AlertDialog(
                        title: const Text("Update"),
                        content: const Text("Updating Profile?"),
                        actions: [
                          //cancel
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              "No",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),

                          //yes
                          TextButton(
                            onPressed: () {
                              Get.back(result: "yesContinue");
                            },
                            child: const Text(
                              "Yes",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (responseOfDialogBox == "yesContinue") {
                      //logout user now
                      //updateProfile();
                      if (formKey.currentState!.validate()) {
                        updateProfile();
                      } else {
                        print('object');
                      }
                    }
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 40,
                    ),
                    child: Text(
                      "Update",
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
    );
  }

  Widget userProfileDisplay(IconData iconData, String userData,
      TextEditingController textController) {
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
        ],
      ),
    );
  }
}
