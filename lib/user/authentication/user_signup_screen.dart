// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:psm_v2/api_connection/api_connection.dart';
import 'package:psm_v2/api_connection/api_connection_laravel.dart';
import 'package:psm_v2/user/authentication/user_login_screen.dart';
import 'package:http/http.dart' as http;

class UserSignUpScreen extends StatefulWidget {
  const UserSignUpScreen({super.key});

  @override
  State<UserSignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var isObsecurePassword = true.obs; //used to display the password
  var isObsecureConfirmPassword =
      true.obs; //used to display the  confirm password

  validateUserEmail() async {
    try {
      var res = await http
          .post(Uri.parse(APILARAVEL.hostConnectEmailValidator), body: {
        'user_email': emailController.text.trim(),
      });

      if (res.statusCode == 200) {
        var resBodyOfValidateUserEmail = jsonDecode(res.body);

        if (resBodyOfValidateUserEmail['emailFound'] == true) {
          Fluttertoast.showToast(
              msg: "Email is already in used. Please try another email");
        } else {
          //Fluttertoast.showToast(msg: "test okay email betul");
          registerAndSaveUserRecord();
        }
      } else {
        print("rte");
      }
    } catch (e) {
      print("Error :: $e");
    }
  }

  registerAndSaveUserRecord() async {
    try {
      var res =
          await http.post(Uri.parse(APILARAVEL.hostConnectRegister), body: {
        "user_name": nameController.text.trim(),
        "user_email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "user_role": "user",
      });

      if (res.statusCode == 200) {
        var resBodyOfSignUpUser = json.decode(res.body);
        if (resBodyOfSignUpUser['success'] == true) {
          Fluttertoast.showToast(msg: "Register successfully");
          setState(() {
            emailController.clear();
            nameController.clear();
            passwordController.clear();
            confirmPasswordController.clear();
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Register Unsuccessfully:: Refresh");
      }
    } catch (e) {
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
                              "Sign Up",
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
              height: MediaQuery.of(context).size.height * 0.75,
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
                      height: 20,
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
                                  height: 20,
                                ),

                                //name
                                TextFormField(
                                  controller: nameController,
                                  validator: (value) =>
                                      value == "" ? "Please write name" : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: Colors.black45,
                                      size: 30,
                                    ),
                                    hintText: "Enter your name...",
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
                                  height: 20,
                                ),

                                //password
                                //wrap with obx because want to change the isObsecure value
                                Obx(
                                  () => TextFormField(
                                    //isObsecure is true. because want make sure the password hidden
                                    obscureText: isObsecurePassword.value,
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
                                            isObsecurePassword.value =
                                                !isObsecurePassword.value;
                                          },
                                          child: Icon(
                                            //if isObsecure false then display visibility off
                                            isObsecurePassword.value
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
                                  height: 20,
                                ),

                                //confirm password
                                //wrap with obx because want to change the isObsecure value
                                Obx(
                                  () => TextFormField(
                                    //isObsecure is true. because want make sure the password hidden
                                    obscureText:
                                        isObsecureConfirmPassword.value,
                                    controller: confirmPasswordController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please write confirm password";
                                      } else if (value !=
                                          passwordController.text) {
                                        return "Password not Match";
                                      } else {
                                        return null;
                                      }
                                    },
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
                                            isObsecureConfirmPassword.value =
                                                !isObsecureConfirmPassword
                                                    .value;
                                          },
                                          child: Icon(
                                            //if isObsecure false then display visibility off
                                            isObsecureConfirmPassword.value
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ),
                                      hintText:
                                          "Enter your confirm password...",
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
                                  height: 20,
                                ),

                                //button
                                Material(
                                  color: Colors.cyan,
                                  borderRadius: BorderRadius.circular(20),
                                  child: InkWell(
                                    onTap: () {
                                      //validateUserEmail
                                      if (formKey.currentState!.validate()) {
                                        validateUserEmail();
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
                            height: 15,
                          ),

                          //dont have account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an Account?",
                                style: TextStyle(color: Colors.grey),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(const UserLoginScreen());
                                },
                                child: const Text(
                                  "Login Here",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
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
