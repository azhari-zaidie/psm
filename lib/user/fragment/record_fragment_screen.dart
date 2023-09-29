import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
//import 'package:psm_v2/api_connection/api_connection.dart';
import 'package:psm_v2/api_connection/api_connection_laravel.dart';
//import 'package:psm_v2/user/fragment/dashboard_fragment_screen.dart';
//import 'package:psm_v2/user/fragment/home_fragment_screen.dart';
//import 'package:psm_v2/user/fragment/learning_fragment_screen.dart';
import 'package:psm_v2/user/model/record.dart';
import 'package:psm_v2/user/quality/water_details_screen.dart';
//import 'package:psm_v2/user/quality/water_quality_screen.dart';
import 'package:psm_v2/user/record/record_details_screen.dart';
import 'package:psm_v2/user/userPreferences/current_user.dart';
import 'package:http/http.dart' as http;

class RecordFragmentScreen extends StatefulWidget {
  const RecordFragmentScreen({super.key});

  @override
  State<RecordFragmentScreen> createState() => _RecordFragmentScreenState();
}

class _RecordFragmentScreenState extends State<RecordFragmentScreen> {
  CurrentUser currentUser = Get.put(CurrentUser());

  getDeleteRecord(int record_id) async {
    try {
      var res = await http.delete(
        Uri.parse(
          APILARAVEL.deleteRecord + record_id.toString(),
        ),
        headers: {
          'Content-type': 'application/json',
        },
      );
      if (res.statusCode == 200) {
        var responseBodyOfDeleteRecord = jsonDecode(res.body);
        if (responseBodyOfDeleteRecord["success"] == true) {
          Fluttertoast.showToast(msg: "Record delete successfully");
          _pullRefresh();
          displayRecordList(context);
        } else {
          print("res");
        }
      } else {
        print("object");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<Record>> getCurrentRecordUser() async {
    List<Record> currentRecordUser = [];

    try {
      var res = await http.get(
        Uri.parse(
          APILARAVEL.readRecord + currentUser.user.user_id.toString(),
        ),
        headers: {
          'Content-type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        var responseBodyOfGetRecord = jsonDecode(res.body);

        if (responseBodyOfGetRecord["success"] == true) {
          (responseBodyOfGetRecord["recordData"] as List)
              .forEach((eachCurrentRecordUser) {
            currentRecordUser.add(Record.fromJson(eachCurrentRecordUser));
          });
          print(currentRecordUser);
        }
      } else {
        print(res.statusCode);
      }
    } catch (e) {
      print("error :: $e");
      //print(currentRecordUser);
    }

    return currentRecordUser;
  }

  Future<void> _pullRefresh() async {
    setState(() {
      //profileWidget(context);
      //favoriteAllItemsWidget(context);
      displayRecordList(context);
    });
    // why use freshNumbers var? https://stackoverflow.com/a/52992836/2301224
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 99, 0, 238),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text('Hint'),
                  content: const Text(
                      'This is record screen that will display all the record that already submitted. Click `+` if want to add new record.\n\nTo delete the record, Hold the selected record and click `Delete`'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(
            Icons.question_mark_sharp,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "History Record",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Get.to(() => WaterQualityScreen());
          //   },
          //   icon: const Icon(
          //     Icons.add,
          //     color: Colors.black,
          //   ),
          // ),
          IconButton(
            onPressed: () {
              Get.to(() => LocationPage());
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //my order and history order
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 8, 0),
                //history icon and my history
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "images/track-record.png",
                        width: 140,
                      ),
                    ),
                    const Text(
                      "My History of Records",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //listing record
            Expanded(
              child: displayRecordList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget displayRecordList(context) {
    return FutureBuilder(
      future: getCurrentRecordUser(),
      builder: (context, AsyncSnapshot<List<Record>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Connection Waiting...",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }

        if (dataSnapShot.data == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Finding the record...",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }

        if (dataSnapShot.data!.length > 0) {
          //function record list ni untuk memudahkan access datasnapshot.data!
          //contoh recordList.length instead of dataSnapShot.data!.length
          List<Record> recordList = dataSnapShot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) {
              return const Divider(
                height: 1,
                thickness: 1,
              );
            },
            itemCount: dataSnapShot.data!.length,
            itemBuilder: (BuildContext context, index) {
              Record eachRecordData = recordList[index];

              return GestureDetector(
                onLongPress: () async {
                  // Show a delete confirmation dialog
                  var responseOfDeleteRecord = await Get.dialog(
                    AlertDialog(
                      title: Text("Delete Record"),
                      content: Text(
                        "Are you sure you want to delete this record?" +
                            "\nThis action cannot be undone" +
                            "\n" +
                            DateFormat("dd MMMM, yyyy")
                                .format(eachRecordData.created_at!) +
                            "-" +
                            DateFormat("hh:mm a")
                                .format(eachRecordData.created_at!.toLocal()),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Get.back(); // Close the dialog
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            // Delete the record here
                            // After deleting, you can update the UI or navigate as needed
                            Get.back(result: "yesContinue"); // Close the dialog
                          },
                          child: Text("Delete"),
                        ),
                      ],
                    ),
                  );

                  if (responseOfDeleteRecord == "yesContinue") {
                    // Delete the record here

                    getDeleteRecord(eachRecordData.record_id!);
                  }
                },
                child: Card(
                  color: Color.fromARGB(255, 3, 218, 197),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: ListTile(
                      onTap: () {
                        //record details screen
                        Get.to(() => RecordDetailsScreen(
                              clickedRecordInfo: eachRecordData,
                            ));
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Average: ${eachRecordData.record_average}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Location: ${eachRecordData.location}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //date
                          //time
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //date
                              Text(
                                DateFormat("dd MMMM, yyyy")
                                    .format(eachRecordData.created_at!),
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              //time
                              Text(
                                DateFormat("hh:mm a").format(
                                    eachRecordData.created_at!.toLocal()),
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            width: 6,
                          ),

                          const Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "No Record Yet...",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          );
        }
      },
    );
  }
}
