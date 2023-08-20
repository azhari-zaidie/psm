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
      var res = await http.post(
        Uri.parse(APILARAVEL.validateFavorite),
        body: jsonEncode(
          {
            "user_id": _currentUser.user.user_id.toString(),
            "makro_id": widget.makroInfo!.makro_id.toString(),
          },
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        var responseBodyOfValidateFavorite = jsonDecode(res.body);

        if (responseBodyOfValidateFavorite["favoriteFound"] == true) {
          print("ada");
          makroDetailsController.setIsFavorite(true);
        } else {
          print("tiada");
          makroDetailsController.setIsFavorite(false);
        }
      } else {
        print("object");
      }
    } catch (e) {
      print("Error :: $e");
    }
  }

  addMakroToFavorite() async {
    try {
      var res = await http.post(
        Uri.parse(APILARAVEL.addFavorite),
        body: jsonEncode(
          {
            "user_id": _currentUser.user.user_id.toString(),
            "makro_id": widget.makroInfo!.makro_id.toString(),
          },
        ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );

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
      var res = await http.post(
        Uri.parse(APILARAVEL.deleteFavorite),
        body: jsonEncode(
          {
            "user_id": _currentUser.user.user_id.toString(),
            "makro_id": widget.makroInfo!.makro_id.toString(),
          },
        ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );

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
      var res = await http.get(
        Uri.parse(
          APILARAVEL.readMakroDetails + widget.makroInfo!.makro_id.toString(),
        ),
        headers: {
          'Content-type': 'application/json',
        },
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
        print(res.request);
      }
    } catch (e) {
      print("Errors :: $e");
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
        backgroundColor: Color.fromARGB(255, 99, 0, 238),
        centerTitle: true,
        title: const Text(
          "Families",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: const BackButton(
          color: Colors.white,
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
                      Expanded(
                        child: Text(
                          widget.makroInfo!.makro_name!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
                    "Macro Scientific name",
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
                          'Features',
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
            child: _selectedIndex == 0 ? makroDetails() : featuresList(context),
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
                    height: 200,
                    width: 300,
                    fit: BoxFit.fill,
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
            Text(
              //API.hostImageMakro + widget.makroInfo!.makro_image!,
              "Image by macroinvertebrates.org",
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
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
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              //alignment: Alignment.center,
              //height: 100,
              //color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RatingBar.builder(
                        initialRating: double.parse(
                            widget.makroInfo!.makro_mark.toString()),
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
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height:
                              10), // Adding spacing between the RatingBar and the text
                      Text(
                        "Bad",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                          height:
                              10), // Adding spacing between the RatingBar and the text
                      Text(
                        "Neutral",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                          height:
                              10), // Adding spacing between the RatingBar and the text
                      Text(
                        "Good",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  )
                ],
              ),
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
          ],
        ),
      ),
    );
  }

  Widget featuresList(context) {
    List<String> featuresMakro = widget.makroInfo!.makro_features!.split("|");

    return ListView.builder(
      itemCount: featuresMakro.length,
      itemBuilder: (BuildContext context, index) {
        Map<String?, dynamic> featureDetails = jsonDecode(featuresMakro[index]);

        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(color: Colors.white12),
            child: Column(
              children: [
                //feature name
                Text(
                  //API.hostImageMakro + widget.makroInfo!.makro_image!,
                  "${featureDetails["feature_name"]}",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
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
                        height: 150,
                        width: 200,
                        fit: BoxFit.cover,
                        placeholder:
                            const AssetImage("images/profile_icon.png"),
                        //image: AssetImage("images/place_holder.png"),
                        image: NetworkImage(
                          APILARAVEL.readMakroImage +
                              featureDetails["feature_image"],
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
                Text(
                  //API.hostImageMakro + widget.makroInfo!.makro_image!,
                  "Image by macroinvertebrates.org",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                Text(
                  featureDetails["feature_desc"],
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(color: Colors.black),
              ],
            ),
          ),
        );
      },
    );
  }
}
