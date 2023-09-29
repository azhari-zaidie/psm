import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:psm_v2/api_connection/api_connection_laravel.dart';
//import 'package:psm_v2/api_connection/api_connection.dart';
import 'package:psm_v2/user/model/record.dart';
import 'package:http/http.dart' as http;

class RecordDetailsScreen extends StatefulWidget {
  final Record? clickedRecordInfo;

  RecordDetailsScreen({this.clickedRecordInfo});

  @override
  State<RecordDetailsScreen> createState() => _RecordDetailsScreenState();
}

class _RecordDetailsScreenState extends State<RecordDetailsScreen> {
  Future<List<RecordItems>> getRecordItems() async {
    List<RecordItems> recordItems = [];

    try {
      var res = await http.get(
        Uri.parse(
          APILARAVEL.readRecordItems +
              widget.clickedRecordInfo!.record_id.toString(),
        ),
        headers: {
          'Content-type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        var responseBodyOfGetRecord = jsonDecode(res.body);
        if (responseBodyOfGetRecord["success"] == true) {
          (responseBodyOfGetRecord["recordItems"] as List)
              .forEach((eachRecord) {
            recordItems.add(RecordItems.fromJson(eachRecord));
          });
        } else {
          print("object");
        }
      } else {
        print("sini");
      }
    } catch (e) {
      print(e);
    }

    return recordItems;
  }

  @override
  Widget build(BuildContext context) {
    double score = widget.clickedRecordInfo!.record_average!;
    IconData iconData;
    String text;

    if (score >= 7.6 && score <= 10) {
      iconData = Icons.sentiment_very_satisfied;
      text = 'Very Clean';
    } else if (score >= 5.1 && score <= 7.59) {
      iconData = Icons.sentiment_satisfied;
      text = 'Almost Clean';
    } else if (score >= 2.6 && score <= 5.09) {
      iconData = Icons.sentiment_neutral;
      text = 'Almost Dirty';
    } else if (score >= 1.0 && score <= 2.59) {
      iconData = Icons.sentiment_dissatisfied;
      text = 'Dirty';
    } else if (score >= 0 && score <= 0.9) {
      iconData = Icons.sentiment_very_dissatisfied;
      text = 'Very Dirty';
    } else {
      iconData = Icons.sentiment_dissatisfied;
      text = 'Very Dirty';
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 99, 0, 238),
        title: const Text(
          "Record Details",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(10),
              color: Color.fromARGB(255, 3, 218, 197),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Biological Water Quality Index: ",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.clickedRecordInfo!.record_average!
                        .toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Location: ${widget.clickedRecordInfo?.location}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Water Classification: ",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          iconData,
                          size: 30,
                        ),
                        Text(
                          text,
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.clickedRecordInfo!.record_desc != null,
            child: Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Text(
                    widget.clickedRecordInfo!.record_desc != null
                        ? widget.clickedRecordInfo!.record_desc!
                        : 'No description',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: displayClickedRecordMakro(),
          ),
        ],
      ),
    );
  }

  displayClickedRecordMakro() {
    return FutureBuilder(
        future: getRecordItems(),
        builder: (context, AsyncSnapshot<List<RecordItems>> dataSnapShot) {
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
            return ListView.builder(
              itemCount: dataSnapShot.data!.length,
              itemBuilder: (BuildContext context, index) {
                final recordItems = dataSnapShot.data!;
                final makro = recordItems[index].makro;
                //RecordItems makroInfo = dataSnapShot.data![index]!.makro!;

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
                        APILARAVEL.hostConnectImage + makro!.url!,
                      ),
                    ),
                    title: Text(makro.makro_name!),
                    subtitle: Text(
                      "Mark for this makro: ${makro.makro_mark!}",
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
                  ))
                ]);
          }
        });
  }
}
