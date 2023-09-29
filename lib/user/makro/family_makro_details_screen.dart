// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, avoid_function_literals_in_foreach_calls, avoid_print, prefer_is_empty

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:psm_v2/api_connection/api_connection.dart';
import 'package:psm_v2/api_connection/api_connection_laravel.dart';
import 'package:psm_v2/user/makro/makro_details_screen.dart';
import 'package:psm_v2/user/model/makro.dart';
import 'package:http/http.dart' as http;

class FamilyMakroDetailsScreen extends StatefulWidget {
  final FamilyMakro? familyInfo;

  FamilyMakroDetailsScreen({this.familyInfo});

  @override
  State<FamilyMakroDetailsScreen> createState() =>
      _FamilyMakroDetailsScreenState();
}

class _FamilyMakroDetailsScreenState extends State<FamilyMakroDetailsScreen> {
  int _selectedIndex = -1;

  Future<List<Makro>> getFamilyMakroDetails() async {
    List<Makro> detailsFamilyMakro = [];

    try {
      var res = await http.get(
        Uri.parse(
            APILARAVEL.readMakroList + widget.familyInfo!.family_id.toString()),
        //body: {
        //'family_id': widget.familyInfo!.family_id.toString(),
        //},
        headers: {
          'Content-type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        var responseOfDetailsFamilyMakro = jsonDecode(res.body);
        if (responseOfDetailsFamilyMakro["success"] == true) {
          (responseOfDetailsFamilyMakro["makroListData"] as List)
              .forEach((eachDetailsMakro) {
            detailsFamilyMakro.add(Makro.fromJson(eachDetailsMakro));
          });
        }
      } else {
        print(res.body);
      }
    } catch (e) {
      print(e);
    }

    return detailsFamilyMakro;
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 99, 0, 238),
        centerTitle: true,
        title: const Text(
          "Orders",
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
                  child: Text(
                    widget.familyInfo!.family_name!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(13, 8, 13, 8),
                  child: Text(
                    widget.familyInfo!.family_scientific_name!,
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
            child: _selectedIndex == 0
                ? familyMakroDetails()
                : familyList(context),
          ),
        ],
      ),
    );
  }

  Widget familyMakroDetails() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(color: Colors.white12),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade600,
                    width: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  child: FadeInImage(
                    height: 300,
                    width: 250,
                    fit: BoxFit.fill,
                    placeholder: const AssetImage("images/profile_icon.png"),
                    //image: AssetImage("images/place_holder.png"),
                    image: NetworkImage(
                      APILARAVEL.hostConnectImage + widget.familyInfo!.url!,
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
              "About the ${widget.familyInfo!.family_name!}",
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
              widget.familyInfo!.family_desc!,
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
        future: getFamilyMakroDetails(),
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
                                      onPressed: () {
                                        Get.to(MakroDetailsScreen(
                                          makroInfo: eachFamilyFound,
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
                                    const AssetImage("images/place_holder.png"),
                                //image: AssetImage("images/place_holder.png"),
                                image: NetworkImage(
                                  APILARAVEL.hostConnectImage +
                                      eachFamilyFound.url!,
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
                child: Text("Empty, No Data."),
              ),
            );
          }
        },
      ),
    );
  }
}
