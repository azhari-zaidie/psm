// ignore_for_file: use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls, avoid_print, prefer_is_empty

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
//import 'package:psm_v2/api_connection/api_connection.dart';
import 'package:psm_v2/api_connection/api_connection_laravel.dart';
import 'package:psm_v2/user/controller/makro_details_controller.dart';
import 'package:psm_v2/user/model/makro.dart';
import 'package:http/http.dart' as http;
import 'package:psm_v2/user/userPreferences/current_user.dart';

class MakroDetailsScreen extends StatefulWidget {
  final Makro? makroInfo;

  const MakroDetailsScreen({this.makroInfo});

  @override
  State<MakroDetailsScreen> createState() => _MakroDetailsScreenState();
}

class _MakroDetailsScreenState extends State<MakroDetailsScreen> {
  MakroDetailsController makroDetailsController =
      Get.put(MakroDetailsController());
  CurrentUser _currentUser = Get.put(CurrentUser());
  int _selectedIndex = -1;

  validateFavorite() async {
    try {
      var res = await http.post(Uri.parse(APILARAVEL.validateFavorite), body: {
        "user_id": _currentUser.user.user_id.toString(),
        "makro_id": widget.makroInfo!.makro_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyOfValidateFavorite = jsonDecode(res.body);

        if (responseBodyOfValidateFavorite["favoriteFound"] == true) {
          print("ada");
          makroDetailsController.setIsFavorite(true);
        } else {
          print("tiada");
          makroDetailsController.setIsFavorite(false);
        }
      }
    } catch (e) {
      print("Error :: $e");
    }
  }

  addMakroToFavorite() async {
    try {
      var res = await http.post(Uri.parse(APILARAVEL.addFavorite), body: {
        "user_id": _currentUser.user.user_id.toString(),
        "makro_id": widget.makroInfo!.makro_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyOfAddToFavorite = jsonDecode(res.body);
        if (responseBodyOfAddToFavorite["success"] == true) {
          Fluttertoast.showToast(msg: "Makro add to Favorite sucessfully");
          validateFavorite();
        } else {
          Fluttertoast.showToast(
              msg: "Error occured: Item not add to Favorite. Try Again.");
        }
      }
    } catch (e) {
      print("Error :: $e");
    }
  }

  deleteFromFavorite() async {
    try {
      var res = await http.post(Uri.parse(APILARAVEL.deleteFavorite), body: {
        "user_id": _currentUser.user.user_id.toString(),
        "makro_id": widget.makroInfo!.makro_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyOfDeleteFavorite = jsonDecode(res.body);
        if (responseBodyOfDeleteFavorite["success"] == true) {
          Fluttertoast.showToast(msg: "Makro delete from Favorite sucessfully");
          validateFavorite();
        } else {
          Fluttertoast.showToast(
              msg: "Error occured: Item not delete from Favorite. Try Again.");
        }
      } else {
        print(APILARAVEL.deleteFavorite);
      }
    } catch (e) {
      print("Error :: $e");
    }
  }

  Future<List<Makro>> getMakroDetails() async {
    List<Makro> detailsMakro = [];

    try {
      var res = await http.post(
        Uri.parse(APILARAVEL.readMakroDetails +
            widget.makroInfo!.makro_id.toString()),
        //body: {
        //"makro_id": widget.makroInfo!.makro_id.toString(),
        //},
      );

      if (res.statusCode == 200) {
        var responseOfDetailsMakro = jsonDecode(res.body);
        if (responseOfDetailsMakro["success"] == true) {
          (responseOfDetailsMakro["makroDetailsData"] as List)
              .forEach((eachDetailsMakro) {
            detailsMakro.add(Makro.fromJson(eachDetailsMakro));
          });
        }
      } else {
        print("test");
      }
    } catch (e) {
      print("Error :: $e");
    }

    return detailsMakro;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    validateFavorite();

    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Families",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 3),
            decoration: BoxDecoration(
              color: Colors.white,
              // this is the container's color
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade600,
                  spreadRadius: 1,
                  blurRadius: 10,
                ), // no shadow color set, defaults to black
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
                  child: Row(
                    children: [
                      Text(
                        widget.makroInfo!.makro_name!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Obx(
                        () => IconButton(
                          onPressed: () {
                            if (makroDetailsController.isFavorite == true) {
                              deleteFromFavorite();
                            } else {
                              addMakroToFavorite();
                            }
                          },
                          icon: Icon(
                            makroDetailsController.isFavorite
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(13, 8, 13, 8),
                  child: Text(
                    "Makro Scientific name",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //overview or details with desc
                    SizedBox(
                      width: 80, // Adjust this value to adjust the spacing
                      child: TextButton(
                        autofocus: _selectedIndex == 0,
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: TextStyle(
                            decoration: _selectedIndex == 0
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            color: Colors.blue,
                          ),
                        ),
                        child: const Text(
                          'Overview',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),

                    //families
                    SizedBox(
                      width: 80, // Adjust this value to adjust the spacing
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: TextStyle(
                            decoration: _selectedIndex == 1
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                        ),
                        child: const Text(
                          'Families',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: _selectedIndex == 0 ? makroDetails() : familyList(context),
          ),
        ],
      ),
    );
  }

  Widget makroDetails() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(color: Colors.white12),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  child: FadeInImage(
                    height: 250,
                    width: 300,
                    fit: BoxFit.cover,
                    placeholder: const AssetImage("images/profile_icon.png"),
                    //image: AssetImage("images/place_holder.png"),
                    image: NetworkImage(
                      APILARAVEL.readMakroImage +
                          widget.makroInfo!.makro_image!,
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
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            //details
            Text(
              //API.hostImageMakro + widget.makroInfo!.makro_image!,
              "About the ${widget.makroInfo!.makro_name!}",
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Mark:  ${widget.makroInfo!.makro_mark!}",
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            //rating
            RatingBar.builder(
              initialRating:
                  double.parse(widget.makroInfo!.makro_mark.toString()),
              minRating: 1,
              maxRating: 10,
              itemCount: 10,
              direction: Axis.horizontal,
              itemBuilder: (context, c) => const Icon(
                Icons.circle,
                color: Colors.black,
              ),
              onRatingUpdate: (updateRating) {},
              ignoreGestures: true,
              unratedColor: Colors.grey.shade400,
              itemSize: 20,
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              widget.makroInfo!.makro_desc!,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            Text(
              widget.makroInfo!.makro_desc!,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            Text(
              widget.makroInfo!.makro_desc!,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget familyList(context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: getMakroDetails(),
        builder: (context, AsyncSnapshot<List<Makro>> dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (dataSnapShot.data == null) {
            return const Center(
              child: Text("No Makro found"),
            );
          }

          if (dataSnapShot.data!.length > 0) {
            return ListView.builder(
              itemCount: dataSnapShot.data!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                Makro eachFamilyFound = dataSnapShot.data![index];
                return Container(
                  margin: EdgeInsets.fromLTRB(
                    16,
                    index == 0 ? 16 : 8,
                    16,
                    index == dataSnapShot.data!.length - 1 ? 16 : 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue,
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: Colors.grey,
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
                                      eachFamilyFound.makro_name!,
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
                                      onPressed: () {},
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
                                      eachFamilyFound.makro_image!,
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
                  /*Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //title and scientific name
                              Text(
                                eachFamilyFound.makro_name!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Scientific name",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),

                              TextButton(
                                onPressed: () {},
                                child: Text(
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
                            API.hostImageMakro + eachFamilyFound.makro_image!,
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
                  ),*/
                );
              },
            );
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text("Empty, No Data."),
              ),
            );
          }
        },
      ),
    );
  }
}
