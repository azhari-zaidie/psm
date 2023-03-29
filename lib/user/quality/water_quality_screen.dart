// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print, prefer_is_empty

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
//import 'package:psm_v2/api_connection/api_connection.dart';
import 'package:psm_v2/api_connection/api_connection_laravel.dart';
import 'package:psm_v2/user/controller/water_test_controller.dart';
import 'package:psm_v2/user/makro/makro_details_screen.dart';
import 'package:psm_v2/user/model/makro.dart';
import 'package:psm_v2/user/record/record_now_screen.dart';

class WaterQualityScreen extends StatefulWidget {
  const WaterQualityScreen({super.key});

  @override
  State<WaterQualityScreen> createState() => _WaterQualityScreenState();
}

class _WaterQualityScreenState extends State<WaterQualityScreen> {
  final makroController = Get.put(WaterTestController());
  getAllMakro() async {
    List<Makro> readAllMakro = [];
    try {
      var res = await http.get(
        Uri.parse(APILARAVEL.readMakro),
      );

      if (res.statusCode == 200) {
        var responseOfReadMakro = jsonDecode(res.body);
        if (responseOfReadMakro["success"] == true) {
          (responseOfReadMakro["makroData"] as List).forEach((eachMakro) {
            readAllMakro.add(Makro.fromJson(eachMakro));
          });
        }

        makroController.setList(readAllMakro);
      }
    } catch (e) {
      print("Erro :: $e");
    }

    calculateTotalMark();
  }

  double calculateTotalMark() {
    makroController.setTotal(0);

    if (makroController.selectedMakroList.length > 0) {
      makroController.makroList.forEach((makroList) {
        if (makroController.selectedMakroList.contains(makroList.makro_id)) {
          makroController.setTotal(makroController.total +
              makroList.makro_mark! /
                  (double.parse(
                      makroController.selectedMakroList.length.toString())));
        }
      });
      print(makroController.total);
    }

    return makroController.total;
  }

  List<Map<String, dynamic>> getSelectedMakroListInformation() {
    List<Map<String, dynamic>> selectedMakroListInformation = [];

    if (makroController.selectedMakroList.length > 0) {
      makroController.makroList.forEach((element) {
        if (makroController.selectedMakroList.contains(element.makro_id)) {
          Map<String, dynamic> makroInformation = {
            "makro_id": element.makro_id,
            "makro_name": element.makro_name,
            "makro_mark": element.makro_mark,
            "makro_image": element.makro_image,
          };

          selectedMakroListInformation.add(makroInformation);
        }
      });
    }
    return selectedMakroListInformation;
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    getAllMakro();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Select Makro",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(
        () => makroController.makroList.length > 0
            ? Stack(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: makroController.makroList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      Makro makroModel = makroController.makroList[index];

                      return GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Description'),
                                content: Column(
                                  children: [
                                    Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              APILARAVEL.readMakroImage +
                                                  makroModel.makro_image!),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      makroModel.makro_desc!,
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),

                                  //see more button
                                  TextButton(
                                    onPressed: () {
                                      Get.to(MakroDetailsScreen(
                                        makroInfo: makroModel,
                                      ));
                                    },
                                    child: const Text('See More'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Card(
                            elevation: 5,
                            child: Column(
                              children: [
                                Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          APILARAVEL.readMakroImage +
                                              makroModel.makro_image!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                Text(
                                  makroModel.makro_name!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),

                                Text(
                                  makroModel.makro_name!,
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                ),

                                //check box
                                GetBuilder(
                                  init: WaterTestController(),
                                  builder: (controller) {
                                    return IconButton(
                                      onPressed: () {
                                        if (makroController.selectedMakroList
                                            .contains(makroModel.makro_id)) {
                                          makroController.deleteSelectedMakro(
                                              makroModel.makro_id!);
                                        } else {
                                          makroController.addSelectedMakro(
                                              makroModel.makro_id!);
                                        }

                                        calculateTotalMark();
                                      },
                                      icon: Icon(
                                        makroController.selectedMakroList
                                                .contains(makroModel.makro_id)
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: Colors.black,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      onPressed: () {
                        if (makroController.selectedMakroList.length > 0) {
                          Get.to(RecordNowScreen(
                            selectedMakroListInfo:
                                getSelectedMakroListInformation(),
                            selectedMakroID: makroController.selectedMakroList,
                            totalMark: makroController.total,
                          ));
                        } else {
                          Fluttertoast.showToast(msg: "Select the Makro");
                        }

                        calculateTotalMark();
                      },
                      child: const Icon(
                        Icons.add,
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: Text("test"),
              ),
      ),
    );
  }
}
