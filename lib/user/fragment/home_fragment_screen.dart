// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print, prefer_is_empty

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:psm_v2/api_connection/api_connection.dart';
import 'package:psm_v2/api_connection/api_connection_laravel.dart';
import 'package:psm_v2/user/model/news.dart';
import 'package:psm_v2/user/userPreferences/current_user.dart';
import 'package:http/http.dart' as http;

class HomeFragmentScreen extends StatefulWidget {
  const HomeFragmentScreen({super.key});

  @override
  State<HomeFragmentScreen> createState() => _HomeFragmentScreenState();
}

class _HomeFragmentScreenState extends State<HomeFragmentScreen> {
  final CurrentUser _currentUser = Get.put(CurrentUser());

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileWidget(context);
  }

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
              // profile widget
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: Image.asset(
                        "images/profile_icon.png",
                        width: 70,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    //profile
                    profileWidget(context),
                  ],
                ),
              ),

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
                  child: const Padding(
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

              // news
              allNewsWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      profileWidget(context);
    });
    // why use freshNumbers var? https://stackoverflow.com/a/52992836/2301224
  }

  //widget display profile
  Widget profileWidget(context) {
    return Container(
      height: 80,
      //decoration: const BoxDecoration(
      //  color: Colors.blue,
      // ),
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _currentUser.user.user_name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            _currentUser.user.user_email,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
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
          return ListView.builder(
            itemCount: dataSnapShot.data!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              News eachNewsRecord = dataSnapShot.data![index];
              return GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    16,
                    index == 0 ? 16 : 8,
                    16,
                    index == dataSnapShot.data!.length - 1 ? 16 : 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.cyan,
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
                                eachNewsRecord.news_title!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //title and desc
                              Text(
                                APILARAVEL.readNewsImage +
                                    eachNewsRecord.main_image!,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
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
                          fit: BoxFit.cover,
                          placeholder:
                              const AssetImage("images/profile_icon.png"),
                          //image: AssetImage("images/place_holder.png"),
                          image: NetworkImage(
                            APILARAVEL.readNewsImage +
                                eachNewsRecord.main_image!,
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
            child: Text("Empty, No Data."),
          );
        }
      },
    );
  }
}
