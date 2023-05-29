import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:psm_v2/api_connection/api_connection_laravel.dart';
import 'package:psm_v2/user/fragment/dashboard_fragment_screen.dart';
import 'package:psm_v2/user/userPreferences/current_user.dart';
import 'package:http/http.dart' as http;
import 'package:validation_textformfield/validation_textformfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({super.key});
  final CurrentUser _currentUser = Get.put(CurrentUser());

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  var isObsecureNewPassword = true.obs; //used to display the password
  var isObsecureConfirmPassword = true.obs;
  var isObsecureCurrentPassword = true.obs;
  var formKey = GlobalKey<FormState>();

  changePassword() async {
    try {
      var res = await http.post(
        Uri.parse(APILARAVEL.changePassword),
        body: jsonEncode(
          {
            'user_email': widget._currentUser.user.user_email,
            'current_password': _currentPasswordController.text,
            'new_password': _newPasswordController.text,
          },
        ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        var responseBodyOfChangePassword = jsonDecode(res.body);
        if (responseBodyOfChangePassword['success']) {
          print("success");
          Fluttertoast.showToast(msg: "Successfully change password");
          Get.to(DasboardFragmentScreen());
        } else {
          Fluttertoast.showToast(msg: "Incorrect current password");
        }
      } else {
        print("status code tk 200");
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
          "Change Password",
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

                //current password
                Obx(
                  () => TextFormField(
                    //isObsecure is true. because want make sure the password hidden
                    obscureText: isObsecureCurrentPassword.value,
                    controller: _currentPasswordController,
                    validator: (value) =>
                        value == "" ? "Password is Empty" : null,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.vpn_key_sharp,
                        color: Colors.black,
                        size: 30,
                      ),
                      //hide and display password
                      suffixIcon: Obx(
                        () => GestureDetector(
                          onTap: () {
                            isObsecureCurrentPassword.value =
                                !isObsecureCurrentPassword.value;
                          },
                          child: Icon(
                            //if isObsecure false then display visibility off
                            isObsecureCurrentPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      hintText: "Enter your current password...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.cyan),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // new password
                //wrap with obx because want to change the isObsecure value
                Obx(
                  () => PassWordValidationTextFiled(
                    //isObsecure is true. because want make sure the password hidden
                    obscureText: isObsecureNewPassword.value,
                    passTextEditingController: _newPasswordController,
                    lineIndicator: false,
                    passwordMinLength: 5,
                    passwordMaxLength: 10,
                    passwordMinError: "Must be more than 5 charater",
                    hasPasswordEmpty: "New Password is Empty",
                    passwordMaxError: "Password too long",
                    passWordUpperCaseError:
                        "at least one Uppercase (Capital) letter",
                    passWordDigitsCaseError: "at least one digit",
                    passwordLowercaseError: "at least one lowercase character",
                    passWordSpecialCharacters:
                        "at least one Special Characters",
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return "Please write new password";
                    //   } else if (value.length < 6) {
                    //     return "Password length need at least 6 character";
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.vpn_key_sharp,
                        color: Colors.black,
                        size: 30,
                      ),
                      //hide and display password
                      suffixIcon: Obx(
                        () => GestureDetector(
                          onTap: () {
                            isObsecureNewPassword.value =
                                !isObsecureNewPassword.value;
                          },
                          child: Icon(
                            //if isObsecure false then display visibility off
                            isObsecureNewPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      hintText: "Enter your new password...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.cyan),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                //confirm password
                //wrap with obx because want to change the isObsecure value
                Obx(
                  () => ConfirmPassWordValidationTextFromField(
                    //isObsecure is true. because want make sure the password hidden
                    obscureText: isObsecureConfirmPassword.value,
                    confirmtextEditingController: _confirmPasswordController,
                    passtextEditingController: _newPasswordController,
                    whenTextFieldEmpty: "Confirm Password is Empty",
                    validatorMassage: "Password not Match",
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return "Please write confirm password";
                    //   } else if (value != _newPasswordController.text) {
                    //     return "Password not Match";
                    //   } else if (value.length < 6) {
                    //     return "Password length need at least 6 character";
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.vpn_key_sharp,
                        color: Colors.black,
                        size: 30,
                      ),
                      //hide and display password
                      suffixIcon: Obx(
                        () => GestureDetector(
                          onTap: () {
                            isObsecureConfirmPassword.value =
                                !isObsecureConfirmPassword.value;
                          },
                          child: Icon(
                            //if isObsecure false then display visibility off
                            isObsecureConfirmPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      hintText: "Enter your confirm password...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.cyan),
                      ),
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
                        title: const Text("Change Password"),
                        content:
                            const Text("Are you sure want to Change Password?"),
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
                        //updatePassword();
                        changePassword();
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
                      "Change Password",
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
}
