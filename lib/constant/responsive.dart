import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget smallScreen;
  const ResponsiveWidget({
    super.key,
    required this.largeScreen,
    required this.smallScreen
    });
  
  static bool isSmallScreen (BuildContext context){
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isLargeScreen (BuildContext context){
    return MediaQuery.of(context).size.width >= 600;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        if(constraints.maxWidth >= 600){
          debugPrint('tablet');
          return largeScreen;
        }else{
          debugPrint('mobile');
          return smallScreen;
        }
      },
    );
  }
}