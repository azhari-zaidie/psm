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
import 'package:psm_v2/user/model/record.dart';
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
          //print(jsonEncode(selectedMakroString));
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
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Selected Makro Overview',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Makro Total Mark: ",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    totalMark!.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'LAT: $latitude '
                    'LGT: $longitude',
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$currentAddress',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ],
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
                      'This is item $index',
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
              title: Text("Calculation?"),
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
