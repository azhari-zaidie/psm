import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:psm_v2/api_connection/api_connection_laravel.dart';
//import 'package:psm_v2/api_connection/api_connection.dart';
import 'package:psm_v2/user/model/record.dart';

class RecordDetailsScreen extends StatefulWidget {
  final Record? clickedRecordInfo;

  RecordDetailsScreen({this.clickedRecordInfo});

  @override
  State<RecordDetailsScreen> createState() => _RecordDetailsScreenState();
}

class _RecordDetailsScreenState extends State<RecordDetailsScreen> {
  @override
  Widget build(BuildContext context) {
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
              color: Color.fromARGB(255, 3, 218, 197),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Macro Total Mark: ",
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
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ],
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
    List<String> clickedRecordMakroInfo =
        widget.clickedRecordInfo!.selected_makro!.split("|");

    return ListView.builder(
      itemCount: clickedRecordMakroInfo.length,
      itemBuilder: (BuildContext context, index) {
        Map<String?, dynamic> makroInfo =
            jsonDecode(clickedRecordMakroInfo[index]);

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
                APILARAVEL.readMakroImage + makroInfo["makro_image"],
              ),
            ),
            title: Text(
              makroInfo["makro_name"],
            ),
            subtitle: Text(
              "Mark for this makro: ${makroInfo["makro_mark"]}",
            ),
          ),
        );
      },
    );
  }
}
