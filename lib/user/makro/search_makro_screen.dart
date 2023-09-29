import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:psm_v2/api_connection/api_connection_laravel.dart';
import 'package:psm_v2/user/makro/makro_details_screen.dart';
import 'package:psm_v2/user/model/makro.dart';

class SearchItems extends StatefulWidget {
  final String? typedKeyWords;

  SearchItems({this.typedKeyWords});

  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {
  TextEditingController searchController = TextEditingController();

  Future<List<Makro>> readSearchRecordFound() async {
    List<Makro> makroSearchList = [];

    if (searchController.text != "") {
      try {
        var res = await http.post(
          Uri.parse(APILARAVEL.searchMakro),
          body: jsonEncode(
            {
              "typedKeyWords": searchController.text,
            },
          ),
          headers: {
            'Content-type': 'application/json',
          },
        );
        if (res.statusCode == 200) {
          var responseBodyOfSearchItems = jsonDecode(res.body);

          if (responseBodyOfSearchItems['success'] == true) {
            //create array untuk favorite LIST

            (responseBodyOfSearchItems['searchData'] as List)
                .forEach((eachItemData) {
              makroSearchList.add(Makro.fromJson(eachItemData));
            });
          }
        } else {
          Fluttertoast.showToast(msg: "Status Code is not 200");
        }
      } catch (errorMsg) {
        print("Error:: " + errorMsg.toString());
      }
    }
    return makroSearchList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    searchController.text = widget.typedKeyWords!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: showSearchBarWidget(),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: searchItemsDesignWidget(context),
    );
  }

  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        style: TextStyle(
          color: Colors.black,
        ),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          hintText: "Search Macro here...",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              searchController.clear();
              setState(() {});
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.purpleAccent),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  Widget searchItemsDesignWidget(context) {
    return FutureBuilder(
      future: readSearchRecordFound(),
      builder: (context, AsyncSnapshot<List<Makro>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapShot.data == null) {
          return const Center(
            child: Text("No trending item found"),
          );
        }
        if (dataSnapShot.data!.length > 0) {
          return ListView.builder(
            itemCount: dataSnapShot.data!.length,
            shrinkWrap: true,
            //physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              Makro eachMakroDetails = dataSnapShot.data![index];
              return GestureDetector(
                onTap: () {
                  Get.to(MakroDetailsScreen(
                    makroInfo: eachMakroDetails,
                  ));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    16,
                    index == 0 ? 16 : 8,
                    16,
                    index == dataSnapShot.data!.length - 1 ? 16 : 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 3, 218, 197),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 0),
                        blurRadius: 6,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //name
                              Row(
                                children: [
                                  //name
                                  Expanded(
                                    child: Text(
                                      eachMakroDetails.makro_name!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 16,
                              ),

                              Row(
                                children: [
                                  //name
                                  Expanded(
                                    child: Text(
                                      eachMakroDetails.makro_desc!,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      //display image clothes
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
                              const AssetImage("images/place_holder.png"),
                          image: NetworkImage(
                            APILARAVEL.hostConnectImage + eachMakroDetails.url!,
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
            child: Text("No Macro Found"),
          );
        }
      },
    );
  }
}
