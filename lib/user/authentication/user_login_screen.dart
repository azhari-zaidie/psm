import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:psm_v2/api_connection/api_connection.dart';
import 'package:psm_v2/api_connection/api_connection_laravel.dart';
import 'package:psm_v2/user/authentication/user_signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:psm_v2/user/fragment/dashboard_fragment_screen.dart';
import 'package:psm_v2/user/model/user.dart';
import 'package:psm_v2/user/userPreferences/user_preferences.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var isObsecure = true.obs; //used to display the password

  loginUserNow() async {
    try {
      var res = await http.post(Uri.parse(APILARAVEL.hostConnectLogin), body: {
        "user_email": emailController.text,
        "password": passwordController.text,
      });

      if (res.statusCode == 200) {
        var responseOfLoginUser = jsonDecode(res.body);
        if (responseOfLoginUser['success']) {
          Fluttertoast.showToast(
              msg: "Login Successfully. \n Welcome to UjiMakro");
          //print(responseOfLoginUser["userData"]);

          //create variable to assign the userData that contain the details of user
          User userInfo = User.fromJson(responseOfLoginUser["userData"]);
          //save userinfo to local storage
          await RememberUserPref.storeUserInfo(userInfo);

          Get.to(const DasboardFragmentScreen());
        } else {
          print(responseOfLoginUser["userData"]);
          Fluttertoast.showToast(
              msg: "Wrong Password or Email \n Please try again.");
        }
      } else {
        // ignore: avoid_print
        print("Error");
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error :: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //header container
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                color: Colors.cyan,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  //header padding
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          //login text
                          Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          //welcome to text
                          Center(
                            child: Text(
                              "Welcome to UjiMakro Apps",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //form
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                //email
                                TextFormField(
                                  controller: emailController,
                                  validator: (value) =>
                                      value == "" ? "Please write email" : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Colors.black45,
                                      size: 30,
                                    ),
                                    hintText: "Enter your email...",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.cyan),
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 25,
                                ),

                                //password
                                //wrap with obx because want to change the isObsecure value
                                Obx(
                                  () => TextFormField(
                                    //isObsecure is true. because want make sure the password hidden
                                    obscureText: isObsecure.value,
                                    controller: passwordController,
                                    validator: (value) => value == ""
                                        ? "Please write password"
                                        : null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.vpn_key_sharp,
                                        color: Colors.black45,
                                        size: 30,
                                      ),
                                      //hide and display password
                                      suffixIcon: Obx(
                                        () => GestureDetector(
                                          onTap: () {
                                            isObsecure.value =
                                                !isObsecure.value;
                                          },
                                          child: Icon(
                                            //if isObsecure false then display visibility off
                                            isObsecure.value
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ),
                                      hintText: "Enter your password...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.cyan),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 40,
                                ),

                                //button
                                Material(
                                  color: Colors.cyan,
                                  borderRadius: BorderRadius.circular(20),
                                  child: InkWell(
                                    onTap: () {
                                      //login user now
                                      if (formKey.currentState!.validate()) {
                                        loginUserNow();
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 50,
                                      ),
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          //dont have account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an Account?",
                                style: TextStyle(color: Colors.grey),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(const UserSignUpScreen());
                                },
                                child: const Text(
                                  "SignUp Here",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
