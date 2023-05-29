import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:psm_v2/user/quality/water_quality_screen.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  int currentStep = 0;
  String? _currentAddress;
  Position? _currentPosition;

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
              if (currentStep == 1) {
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
              } else if (currentStep != 1) {
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
                title: Text('Information'),
                content: Text(
                  'Please be careful and always watch your step. Firstly, prepare the tools to collect the Macro. After the preparation is done. Click continue to proceed next step.',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              Step(
                isActive: currentStep >= 1,
                title: const Text('Set My Location'),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('LAT: ${_currentPosition?.latitude ?? ""}'),
                    Text('LNG: ${_currentPosition?.longitude ?? ""}'),
                    Text('ADDRESS: ${_currentAddress ?? ""}'),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _getCurrentPosition,
                      child: const Text("Get Current Location"),
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
