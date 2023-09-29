import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:psm_v2/user/quality/water_quality_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  int currentStep = 0;
  String? _currentAddress;
  Position? _currentPosition;

  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'Or0ExPBgI2s',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];

    setState(() {
      _currentAddress =
          '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }
  // Future<void> _getAddressFromLatLng(Position position) async {
  //   await placemarkFromCoordinates(
  //           _currentPosition!.latitude, _currentPosition!.longitude)
  //       .then((List<Placemark> placemarks) {
  //     Placemark place = placemarks[0];
  //     setState(() {
  //       _currentAddress =
  //           '${place.street}, ${place.postalCode}, ${place.country}';
  //     });
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color.fromARGB(255, 99, 0, 238),
        centerTitle: true,
        title: const Text(
          'Macro',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Theme(
          data: ThemeData(
            canvasColor: Colors.white,
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Color.fromARGB(255, 99, 0, 238),
                  background: Colors.red,
                  secondary: Colors.black,
                ),
          ),
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: currentStep,
            onStepContinue: () {
              if (currentStep == 2) {
                if (_currentPosition?.latitude == null ||
                    _currentPosition?.longitude == null ||
                    _currentAddress == null) {
                  Fluttertoast.showToast(msg: "Current Location Needed");
                } else {
                  Get.to(WaterQualityScreen(
                    latitude: _currentPosition?.latitude,
                    longitude: _currentPosition?.longitude,
                    currentLocation: _currentAddress,
                  ));
                }
              } else if (currentStep != 2) {
                setState(() => currentStep++);
              }
            },
            onStepCancel: () {
              if (currentStep != 0) {
                setState(() => currentStep--);
              }
            },
            steps: [
              Step(
                isActive: currentStep >= 0,
                title: Text('Preparation'),
                content: SingleChildScrollView(
                    child: Column(
                  children: [
                    Text(
                      "Persediaan Aktiviti Persampelan",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Text(
                      "Sebelum memulakan aktiviti persampelan, alat pelindung diri seperti Wader, Sarung tangan dan Pelindung mata perlu dipakai.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Perkara-perkara yang perlu diberi perhatian sebelum aktiviti persampelan: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "1. Elakkan melakukan aktiviti di mana dan apabila terdapat kemungkinan banjir kilat." +
                          "\n2. Periksa apakah ada empangan di atas tapak persampelan." +
                          "\n3. Ketahui di mana air dilepaskan." +
                          "\n4. Hanya melakukan aktiviti di air cetek tanpa arus kuat atau batu licin.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                )),
              ),
              Step(
                  isActive: currentStep >= 1,
                  title: Text('Instruction'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Langkah-langkah Persampelan Petunujuk Bio\n(MAKROINVERTEBRATA)",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "1. Mengisi air sungai ke dalam bekas yang disediakan di dalam kit." +
                              "\n2. Dua kaedah untuk cari makroinvertebrata di dalam air:" +
                              "\n\t\ti. Mengodak menggunakan kaki dan menangkan jaring. Mengeluarkan haiwan dari jaring dan meletakkannya di dalam bekas; atau" +
                              "\n\t\tii. Menggunakan batu atau daun dan digocakkan di dalam bekas." +
                              "\n3. Bagi memudahakn proses mengenal pasti makroinvertebrata, haiwan perlu dipindahkan ke piring petri dengan menggunakan sudu atau penitis. Satu jenis haiwan bagi satu piring petri." +
                              "\n4. Meletakkan piring petri di atas permukaan yang cerah dan kenal pasti makroinvertebrata melalui kanta pembesar.",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Text(
                          "Video Pembelajaran",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                          thickness: 0,
                        ),
                        YoutubePlayer(
                          controller: _controller!,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.amber,
                          progressColors: ProgressBarColors(
                            playedColor: Colors.amber,
                            handleColor: Colors.amberAccent,
                          ),
                          onReady: () {
                            _controller!.addListener(() {});
                          },
                        ),
                      ],
                    ),
                  )),
              Step(
                isActive: currentStep >= 2,
                title: const Text('Location'),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Dapatkan Lokasi Persampelan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Text(
                      'LATITUDE: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${_currentPosition?.latitude ?? ""}",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'LONGITUDE: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${_currentPosition?.longitude ?? ""}",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'ADDRESS: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${_currentAddress ?? ""}",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _getCurrentPosition,
                      child: const Text("Get Location"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text("Location Page")),
  //     body: SafeArea(
  //       child: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text('LAT: ${_currentPosition?.latitude ?? ""}'),
  //             Text('LNG: ${_currentPosition?.longitude ?? ""}'),
  //             Text('ADDRESS: ${_currentAddress ?? ""}'),
  //             const SizedBox(height: 32),
  //             ElevatedButton(
  //               onPressed: _getCurrentPosition,
  //               child: const Text("Get Current Location"),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
