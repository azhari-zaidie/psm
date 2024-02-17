import 'package:flutter/material.dart';
import 'package:psm_v2/ui/mobile/auth/login.dart';

class AppRoutes{
  static String login = "/login";

  static Map<String, WidgetBuilder> getRoutes(){
    return {
      login : (BuildContext context) => LoginScreen(),
    };
  }
}