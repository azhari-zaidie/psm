// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print, prefer_is_empty

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
//import 'package:psm_v2/api_connection/api_connection.dart';
import 'package:psm_v2/api_connection/api_connection_laravel.dart';
import 'package:psm_v2/user/makro/family_makro_details_screen.dart';
import 'package:psm_v2/user/model/makro.dart';
import 'package:http/http.dart' as http;
import 'package:psm_v2/user/model/news.dart';

class LearningFragmentScreen extends StatefulWidget {
  const LearningFragmentScreen({super.key});

  @override
  State<LearningFragmentScreen> createState() => _LearningFragmentScreenState();
}

class _LearningFragmentScreenState extends State<LearningFragmentScreen> {
  int _selectedIndex = -1;

  final List<Learning> learning = [
    Learning(
      learning_title: 'Calculation Formula',
      learning_name:
          'ASPT is used to calculate the Average of macro to determine the quality',
      learning_desc:
          'The Average Score Per Taxon (ASPT) represents the average tolerance score of all taxa within the community, and is calculated by dividing the BMWP by the number of families/taxa represented in the sample. ' +
              '\nThe formula is: \nSum of every makro / Total makro found',
    ),
    Learning(
      learning_title: 'Item 1',
      learning_name: 'How to Take Sample?',
      learning_desc: 'The instruction of how to Take sample need to be done properly to get clear result. \n' +
          '1. Filing the river water into tray that in the kit' +
          '\n2. Two methods for finding macroinvertabrates in water: ' +
          '\n   i. Using the legs and cathing using a net. Removing the animal from the net and placing it in a container; Or' +
          '\n   ii. Using stones or leaves and being boosted in water, in containers' +
          '\n3. In facilitate the process of identifying macroinvertebrate, the animalshould be transferred to petri dish using a spoon or dropper. A type of animal for one petri dish' +
          '\n4. Place a petri dish on a sunny surface and identify the animal through a magnifying lens and refer to the classification module.',
    ),
    Learning(
      learning_title: 'Item 1',
      learning_name: 'How to test water quality using this UjiMakro Apps?',
      learning_desc: 'There is two way that can be done: ' +
          '\n1. In homepage there is a take sample button, user can simply click on it'
              '\n2. User can go to records page. At the top right page will have + icon. Click on it',
    ),
    Learning(
      learning_title: 'Item 1',
      learning_name: 'Macroinvertebrates as Bioindicators of Water Quality',
      learning_desc:
          'Macroinvertebrates like insects, crustaceans, and worms can indicate water quality. Their presence, abundance, and diversity reflect pollution levels, helping monitor and manage ecosystems.',
    ),
    Learning(
      learning_title: 'Item 1',
      learning_name: 'Assessing Water Quality Using Macroinvertebrate Metrics',
      learning_desc:
          'By analyzing macroinvertebrate communities, metrics like BMWP and EPT can quantify water quality. Higher scores indicate better health, aiding in environmental assessments and decision-making.',
    ),
  ];

  Future<List<FamilyMakro>> readFamilyMakro() async {
    List<FamilyMakro> familyMakroList = [];
    try {
      var res = await http.get(
        Uri.parse(APILARAVEL.readFamilyMakro),
        headers: {
          'Content-type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        var responseOfAllFamilyMakro = jsonDecode(res.body);
        if (responseOfAllFamilyMakro["success"]) {
          (responseOfAllFamilyMakro["familyMakroData"] as List)
              .forEach((eachFamilyMakro) {
            familyMakroList.add(FamilyMakro.fromJson(eachFamilyMakro));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Status code is not 200");
      }
    } catch (e) {
      print("Error :: $e");
    }
    return familyMakroList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedIndex = 0;
  }

  Future<void> _pullRefresh() async {
    setState(() {
      //profileWidget(context);
      //favoriteAllItemsWidget(context);
      allFamilyMakro(context);
      learningList(context);
    });
    // why use freshNumbers var? https://stackoverflow.com/a/52992836/2301224
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 99, 0, 238),
        centerTitle: true,
        title: const Text(
          "Learning Field",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //overview or details with desc
                  SizedBox(
                    width: 100, // Adjust this value to adjust the spacing
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
                        'Categories',
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
                        'Guide',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                  child: _selectedIndex == 0
                      ? SingleChildScrollView(
                          child: allFamilyMakro(context),
                        )
                      : learningList(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget learningList(context) {
    return ListView.builder(
      itemCount: learning.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Card(
            elevation: 5,
            shadowColor: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(learning[index].learning_name!),
                subtitle: Text(learning[index].learning_desc!),
                onTap: () {},
              ),
            ),
          ),
        );
      },
    );
  }

  Widget allFamilyMakro(context) {
    return FutureBuilder(
      future: readFamilyMakro(),
      builder: (context, AsyncSnapshot<List<FamilyMakro>> dataSnapShot) {
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
              FamilyMakro eachFamilyFound = dataSnapShot.data![index];
              return GestureDetector(
                onTap: () {
                  //go to family makro details]
                  Get.to(FamilyMakroDetailsScreen(familyInfo: eachFamilyFound));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    16,
                    index == 0 ? 16 : 8,
                    16,
                    index == dataSnapShot.data!.length - 1 ? 16 : 8,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade600,
                          spreadRadius: 1,
                          blurRadius: 2,
                        )
                      ]),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                eachFamilyFound.family_name!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //title and desc
                              Text(
                                eachFamilyFound.family_desc!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                        child: FadeInImage(
                          height: 130,
                          width: 130,
                          fit: BoxFit.cover,
                          placeholder:
                              const AssetImage("images/profile_icon.png"),
                          //image: AssetImage("images/place_holder.png"),
                          image: NetworkImage(
                            APILARAVEL.hostConnectImage + eachFamilyFound.url!,
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
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: Text("No Family Macro"),
          );
        }
      },
    );
  }
}
