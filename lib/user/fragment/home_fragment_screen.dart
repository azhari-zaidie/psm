// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print, prefer_is_empty

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:psm_v2/api_connection/api_connection.dart';
import 'package:psm_v2/api_connection/api_connection_laravel.dart';
import 'package:psm_v2/user/makro/makro_details_screen.dart';
import 'package:psm_v2/user/makro/search_makro_screen.dart';
import 'package:psm_v2/user/model/makro.dart';
import 'package:psm_v2/user/model/news.dart';
import 'package:psm_v2/user/quality/water_details_screen.dart';
import 'package:psm_v2/user/userPreferences/current_user.dart';
import 'package:http/http.dart' as http;

class HomeFragmentScreen extends StatefulWidget {
  const HomeFragmentScreen({super.key});

  @override
  State<HomeFragmentScreen> createState() => _HomeFragmentScreenState();
}

class _HomeFragmentScreenState extends State<HomeFragmentScreen> {
  TextEditingController searchController = TextEditingController();
  final CurrentUser _currentUser = Get.put(CurrentUser());
  // int _currentPage = 0;
  // Timer? _timer;
  // PageController _pageController = PageController(
  //   initialPage: 0,
  // );
  List<String> images = [
    "https://images.wallpapersden.com/image/download/purple-sunrise-4k-vaporwave_bGplZmiUmZqaraWkpJRmbmdlrWZlbWU.jpg",
    "https://wallpaperaccess.com/full/2637581.jpg",
    "https://uhdwallpapers.org/uploads/converted/20/01/14/the-mandalorian-5k-1920x1080_477555-mm-90.jpg"
  ];

  Future<List<Makro>> getLatestMakros() async {
    List<Makro> allMakro = [];
    try {
      var res = await http.get(
        Uri.parse(APILARAVEL.readMakro),
        headers: {
          'Content-type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        var responseOfAllNews = jsonDecode(res.body);
        if (responseOfAllNews["success"] == true) {
          (responseOfAllNews["makroData"] as List).forEach((eachMakro) {
            allMakro.add(Makro.fromJson(eachMakro));
          });
        }
      } else {
        print(res.statusCode);
      }
    } catch (e) {
      print("Error :: $e");
    }
    return allMakro;
  }

  Future<List<News>> getAllNews() async {
    List<News> allNewsList = [];
    try {
      var res = await http.get(
        Uri.parse(APILARAVEL.readNews),
        headers: {
          'Content-type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        var responseOfAllNews = jsonDecode(res.body);
        if (responseOfAllNews["success"] == true) {
          (responseOfAllNews["newsData"] as List).forEach((eachNews) {
            allNewsList.add(News.fromJson(eachNews));
          });
        }
      } else {
        print(res.statusCode);
      }
    } catch (e) {
      print("Error :: $e");
    }
    return allNewsList;
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   //every pageview is scrolled sideways it will take the index page
  //   _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
  //     if (_currentPage < 2) {
  //       _currentPage++;
  //     } else {
  //       _currentPage = 0;
  //     }

  //     _pageController.animateToPage(
  //       _currentPage,
  //       duration: Duration(milliseconds: 350),
  //       curve: Curves.easeIn,
  //     );
  //   });
  //   super.initState();
  //   profileWidget(context);
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _timer?.cancel();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              //search bar widget
              showSearchBarWidget(),

              const SizedBox(
                height: 16,
              ),
              //button2
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: IconButton(
                              onPressed: () {
                                // Button action
                                Get.to(() => LocationPage());
                              },
                              icon: Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Add Sampling',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    // const SizedBox(
                    //   width: 30,
                    // ),
                    // Column(
                    //   children: [
                    //     Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 18),
                    //       child: Container(
                    //         width: 50,
                    //         height: 50,
                    //         decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           color: Colors.blue,
                    //         ),
                    //         child: IconButton(
                    //           onPressed: () {
                    //             // Button action
                    //             Get.to(FavoriteMakroScreen());
                    //           },
                    //           icon: Icon(
                    //             Icons.favorite,
                    //             size: 20,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     Text(
                    //       'Favorite',
                    //       style: TextStyle(fontSize: 14),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),

              const Divider(color: Colors.black),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "Welcome to UjiMakro",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              SizedBox(
                height: 200,
                width: 400,
                child: allNewsWidget(context),
              ),

              // Buttons
              // about us
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About this Apps",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          textAlign: TextAlign.justify,
                          "This apps is a Water quality test based on Macroinvertebrate. This apps also allow user learn the type of Macroinvertebrates.",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "Latest Macro",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              // List view
              Container(
                height: MediaQuery.of(context).size.height,
                child: allLatestMakro(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        style: TextStyle(color: Colors.black),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () {
              Get.to(SearchItems(typedKeyWords: searchController.text));
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          hintText: "Search Macro here...",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          // suffixIcon: IconButton(
          //   onPressed: () {
          //     //Get.to(CartListScreen());
          //   },
          //   icon: const Icon(
          //     Icons.book,
          //     color: Colors.black,
          //   ),
          // ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.purpleAccent),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      //profileWidget(context);
      allNewsWidget(context);
      allLatestMakro(context);
    });
    // why use freshNumbers var? https://stackoverflow.com/a/52992836/2301224
  }

  //widget display profile
  // Widget profileWidget(context) {
  //   return Container(
  //     height: 80,
  //     //decoration: const BoxDecoration(
  //     //  color: Colors.blue,
  //     // ),
  //     padding: const EdgeInsets.all(5),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           _currentUser.user.user_name,
  //           style: const TextStyle(
  //             fontWeight: FontWeight.bold,
  //             fontSize: 20,
  //           ),
  //         ),
  //         Text(
  //           _currentUser.user.user_email,
  //           style: const TextStyle(
  //             fontSize: 14,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  showNewsPopup(BuildContext context, News newsRecord) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text(
              newsRecord.news_title!,
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        APILARAVEL.readNewsImage + newsRecord.main_image!,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  newsRecord.news_desc!,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  //widget display news
  Widget allNewsWidget(context) {
    return FutureBuilder(
      future: getAllNews(),
      builder: (context, AsyncSnapshot<List<News>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapShot.data == null) {
          return const Center(
            child: Text("No news found"),
          );
        }

        if (dataSnapShot.data!.length > 0) {
          return SizedBox(
            height: 260,
            child: ListView.builder(
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                News eachNewsRecord = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: () {
                    //Get.to(ItemDetailsScreen(itemInfo: eachClothItemData));
                    showNewsPopup(context, eachNewsRecord);
                  },
                  child: Container(
                    width: 200,
                    margin: EdgeInsets.fromLTRB(index == 0 ? 16 : 8, 10,
                        index == dataSnapShot.data!.length - 1 ? 16 : 8, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 3, 218, 197),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 3),
                          blurRadius: 6,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        //display gmbar dari database
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(22),
                            topRight: Radius.circular(22),
                          ),
                          child: FadeInImage(
                            height: 100,
                            width: 200,
                            fit: BoxFit.cover,
                            placeholder:
                                const AssetImage("images/place_holder.png"),
                            image: NetworkImage(
                              APILARAVEL.readNewsImage +
                                  eachNewsRecord.main_image!,
                            ),
                            imageErrorBuilder:
                                (context, error, stackTraceError) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                ),
                              );
                            },
                          ),
                        ),

                        //display nama dan harga bagi setiap item
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //display nama dan harga bagi setiap item
                              Row(
                                children: [
                                  //nama item
                                  Expanded(
                                    child: Text(
                                      eachNewsRecord.news_title!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              Row(
                                children: [
                                  //nama item
                                  Expanded(
                                    child: Text(
                                      eachNewsRecord.news_desc!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text("Empty, No Data."),
          );
        }
      },
    );
  }

  //widget display latest makros
  Widget allLatestMakro(context) {
    return FutureBuilder(
      future: getLatestMakros(),
      builder: (context, AsyncSnapshot<List<Makro>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapShot.data == null) {
          return const Center(
            child: Text("No latest macros found"),
          );
        }

        if (dataSnapShot.data!.length > 0) {
          //int itemCount = min(5, max(1, dataSnapShot.data!.length));
          return ListView.builder(
            itemCount: 5,
            shrinkWrap: false,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              Makro eachMakroDetails = dataSnapShot.data![index];
              return GestureDetector(
                onTap: () {
                  Get.to(MakroDetailsScreen(
                    makroInfo: eachMakroDetails,
                  ));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    16,
                    index == 0 ? 16 : 8,
                    16,
                    index == dataSnapShot.data!.length - 1 ? 16 : 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 3, 218, 197),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 0),
                        blurRadius: 6,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                eachMakroDetails.makro_name!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //title and desc
                              Text(
                                eachMakroDetails.makro_desc!,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: FadeInImage(
                          height: 130,
                          width: 130,
                          fit: BoxFit.fill,
                          placeholder:
                              const AssetImage("images/profile_icon.png"),
                          //image: AssetImage("images/place_holder.png"),
                          image: NetworkImage(
                            APILARAVEL.readMakroImage +
                                eachMakroDetails.makro_image!,
                          ),
                          imageErrorBuilder: (context, error, stackTraceError) {
                            return const Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: Text("No Macro Found."),
          );
        }
      },
    );
  }
}
