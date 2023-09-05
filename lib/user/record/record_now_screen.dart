import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:geocoding/geocoding.dart';
// 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
//import 'package:psm_v2/api_connection/api_connection.dart';
import 'package:psm_v2/api_connection/api_connection_laravel.dart';
import 'package:psm_v2/user/controller/water_test_controller.dart';
import 'package:psm_v2/user/fragment/dashboard_fragment_screen.dart';
//import 'package:psm_v2/user/fragment/home_fragment_screen.dart';
//import 'package:psm_v2/user/fragment/record_fragment_screen.dart';
//import 'package:psm_v2/user/model/record.dart';
import 'package:psm_v2/user/userPreferences/current_user.dart';
import 'package:http/http.dart' as http;

class RecordNowScreen extends StatelessWidget {
  final List<Map<String, dynamic>>? selectedMakroListInfo;
  final double? totalMark;
  final List<int>? selectedMakroID;
  final double? latitude;
  final double? longitude;
  final String? currentAddress;

  CurrentUser currentUser = Get.put(CurrentUser());
  WaterTestController makroController = Get.put(WaterTestController());

  TextEditingController descController = TextEditingController();

  RecordNowScreen({
    this.selectedMakroListInfo,
    this.totalMark,
    this.selectedMakroID,
    this.latitude,
    this.longitude,
    this.currentAddress,
  });

  saveRecordMakro() async {
    String selectedMakroString = selectedMakroListInfo!
        .map((eachSelectedMakro) => jsonEncode(eachSelectedMakro))
        .toList()
        .join("|");

    // Record record = Record(
    //   selected_makro: selectedMakroString,
    //   user_id: currentUser.user.user_id,
    //   record_average: totalMark,
    //   location: currentAddress,
    //   latitude: latitude,
    //   longitude: longitude,
    // );

    // Map<String, dynamic> data = {
    //   'selected_record': "selectedMakroString",
    //   'user_id': 18,
    //   'record_average': 4.5,
    // };

    try {
      var res = await http.post(
        Uri.parse(APILARAVEL.addRecord),
        body: //record.toJson,
            jsonEncode(
          {
            "selected_makro": selectedMakroString,
            "user_id": currentUser.user.user_id,
            "record_average": totalMark,
            "location": currentAddress,
            "latitude": latitude,
            "longitude": longitude,
            "record_desc": descController.text,
          },
        ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        var responseBodyOfAddNewRecord = jsonDecode(res.body);

        if (responseBodyOfAddNewRecord["success"] == true) {
          Fluttertoast.showToast(msg: "Success");
          print(
            descController.text,
          );
          Get.to(DasboardFragmentScreen());
        } else {
          print("Error ::");
        }
      } else {
        print(jsonEncode(selectedMakroString));
        //print(json.encode(data));
      }
    } catch (e) {
      print("Error :: $e");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color.fromARGB(255, 99, 0, 238),
        centerTitle: true,
        title: const Text(
          'Selected Makro Overview',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Color.fromARGB(255, 3, 218, 197),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Macro Total Average: ",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    totalMark!.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '$currentAddress',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: descController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: selectedMakroListInfo!.length,
              itemBuilder: (BuildContext context, index) {
                Map<String, dynamic> eachSelectedMakro =
                    selectedMakroListInfo![index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade900,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        APILARAVEL.readMakroImage +
                            eachSelectedMakro["makro_image"],
                      ),
                    ),
                    title: Text(
                      eachSelectedMakro["makro_name"],
                    ),
                    subtitle: Text(
                      "Score for this Makro: " +
                          eachSelectedMakro["makro_mark"].toString(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //passing dialog box with parameter
          var responseFromDialogBox = await Get.dialog(
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              iconColor: Color.fromARGB(255, 99, 0, 238),
              title: Text("Calculation"),
              //titlePadding: const EdgeInsets.all(0),
              content: const Text(
                  "Are you sure want to Continue to the Calculation Step?"),
              actions: [
                //cancel
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

                //yes
                TextButton(
                  onPressed: () {
                    Get.back(result: "yesContinue");
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          );

          if (responseFromDialogBox == "yesContinue") {
            makroController.clearAllSelectedMakro();
            saveRecordMakro();
          }
        },
        child: Text(
          "Next",
        ),
      ),
    );
  }
}