// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psm_v2/user/fragment/favorite_fragement_screen.dart';
import 'package:psm_v2/user/fragment/home_fragment_screen.dart';
import 'package:psm_v2/user/fragment/learning_fragment_screen.dart';
import 'package:psm_v2/user/fragment/profile_fragment_screen.dart';
import 'package:psm_v2/user/fragment/record_fragment_screen.dart';
import 'package:psm_v2/user/userPreferences/current_user.dart';

class DasboardFragmentScreen extends StatefulWidget {
  const DasboardFragmentScreen({super.key});

  @override
  State<DasboardFragmentScreen> createState() => _DasboardFragmentScreenState();
}

class _DasboardFragmentScreenState extends State<DasboardFragmentScreen> {
  // ignore: prefer_final_fields
  CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  //create a bottom navigation bar icon
  //create a navigation list
  final List<Widget> _fragmentScreens = [
    HomeFragmentScreen(),
    LearningFragmentScreen(),
    FavoriteFragmentScreen(),
    RecordFragmentScreen(),
    ProfileFragmentScreen(),
  ];

  //create button nav bar properties, such as icon and label
  final List _navigationButtonsProperties = [
    {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined,
      "label": "Home",
    },
    {
      "active_icon": Icons.auto_stories,
      "non_active_icon": Icons.auto_stories_outlined,
      "label": "Learning",
    },
    {
      "active_icon": Icons.favorite,
      "non_active_icon": Icons.favorite_border,
      "label": "Favorite",
    },
    {
      "active_icon": Icons.book,
      "non_active_icon": Icons.book_outlined,
      "label": "Records",
    },
    {
      "active_icon": Icons.person,
      "non_active_icon": Icons.person_outline,
      "label": "Profile",
    },
  ];

  //assign indexnumber =0
  final RxInt _indexNumber = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentState) {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Obx(
              () => _fragmentScreens[_indexNumber.value],
            ),
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.black26, width: 1.0),
              ),
            ),
            child: Obx(
              () => BottomNavigationBar(
                currentIndex: _indexNumber.value,
                onTap: (value) {
                  _indexNumber.value = value;
                },
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedItemColor: Colors.lime,
                unselectedItemColor: Colors.grey,
                items: List.generate(5, (index) {
                  var navBtnProperty = _navigationButtonsProperties[index];
                  return BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(navBtnProperty["non_active_icon"]),
                    activeIcon: Icon(navBtnProperty["active_icon"]),
                    label: navBtnProperty["label"],
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}
