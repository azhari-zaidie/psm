import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psm_v2/user/authentication/user_login_screen.dart';
import 'package:psm_v2/user/fragment/dashboard_fragment_screen.dart';
import 'package:psm_v2/user/userPreferences/user_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'UjiMakro1',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      home: FutureBuilder(
        future: RememberUserPref.readUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const UserLoginScreen();
          } else {
            return const DasboardFragmentScreen();
          }
        },
      ),
    );
  }
}
