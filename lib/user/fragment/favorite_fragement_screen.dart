import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
//import 'package:psm_v2/api_connection/api_connection.dart';
import 'package:psm_v2/api_connection/api_connection_laravel.dart';
import 'package:psm_v2/user/makro/makro_details_screen.dart';
import 'package:psm_v2/user/model/favorite.dart';
import 'package:psm_v2/user/model/makro.dart';
import 'package:psm_v2/user/userPreferences/current_user.dart';
import 'package:http/http.dart' as http;

class FavoriteFragmentScreen extends StatelessWidget {
  FavoriteFragmentScreen({super.key});

  final CurrentUser _currentUser = Get.put(CurrentUser());

  Future<List<Favorite>> getCurrentUserFavorite() async {
    List<Favorite> currentUserFavorite = [];

    try {
      var res = await http.get(
        Uri.parse(
          APILARAVEL.readFavorite + _currentUser.user.user_id.toString(),
        ),
        headers: {
          'Content-type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        var responseBodyOfReadCurrentUserFavorite = jsonDecode(res.body);

        if (responseBodyOfReadCurrentUserFavorite["success"] == true) {
          (responseBodyOfReadCurrentUserFavorite["currentUserFavoriteData"]
                  as List)
              .forEach((eachCurrentUserFavoriteItem) {
            currentUserFavorite
                .add(Favorite.fromJson(eachCurrentUserFavoriteItem));
          });
        } else {
          print("sini");
        }
      } else {
        print(res.body);
        print(currentUserFavorite);
        Fluttertoast.showToast(msg: "Error :: Status code is not 200");
      }
    } catch (e) {
      print("Error :: $e");
    }
    return currentUserFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 8, 8),
            child: Text(
              "My Favorite List",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 8, 8),
            child: Text(
              "Learn about your favorite Macros.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          //displaying favoritelist
          favoriteAllItemsWidget(context),
        ],
      ),
    );
  }

  Widget favoriteAllItemsWidget(context) {
    return FutureBuilder(
      future: getCurrentUserFavorite(),
      builder: (context, AsyncSnapshot<List<Favorite>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapShot.data == null) {
          return const Center(
            child: Text("No trending item found",
                style: TextStyle(color: Colors.grey)),
          );
        }
        if (dataSnapShot.data!.length > 0) {
          return ListView.builder(
            itemCount: dataSnapShot.data!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              Favorite eachFavoriteFound = dataSnapShot.data![index];

              Makro eachMakroDetails = Makro(
                makro_id: eachFavoriteFound.makro_id,
                makro_name: eachFavoriteFound.makro_name,
                makro_desc: eachFavoriteFound.makro_desc,
                makro_image: eachFavoriteFound.makro_image,
                family_id: eachFavoriteFound.family_id,
                makro_mark: eachFavoriteFound.makro_mark,
                makro_features: eachFavoriteFound.makro_features,
              );
              return Container(
                margin: EdgeInsets.fromLTRB(
                  16,
                  index == 0 ? 16 : 8,
                  16,
                  index == dataSnapShot.data!.length - 1 ? 16 : 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(255, 99, 0, 238),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: Color.fromARGB(255, 3, 218, 197),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //title and scientific name
                                  Text(
                                    eachFavoriteFound.makro_name!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const Text(
                                    "Scientific name",
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Get.to(MakroDetailsScreen(
                                        makroInfo: eachMakroDetails,
                                      ));
                                    },
                                    child: const Text(
                                      "See more...",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FadeInImage(
                              height: 130,
                              width: 200,
                              fit: BoxFit.cover,
                              placeholder:
                                  const AssetImage("images/profile_icon.png"),
                              //image: AssetImage("images/place_holder.png"),
                              image: NetworkImage(
                                APILARAVEL.readMakroImage +
                                    eachFavoriteFound.makro_image!,
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
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("Empty, No Favorite."),
            ),
          );
        }
      },
    );
  }
}
