import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng _initialCameraPosition = LatLng(20.5937, 78.9629);
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      rootBundle.loadString("assets/style/map_style.txt").then((string) {
        _mapStyle = string;
      });
    });

    _checkPermissionAndService();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    controller.setMapStyle(_mapStyle);

    // Geolocator.getPositionStream().listen((Position position) {
    //   controller.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(
    //           target: LatLng(position.latitude, position.longitude),
    //           zoom: 17.5),
    //     ),
    //   );
    // });

    //Get current geo-position
    var _currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target:
                LatLng(_currentLocation.latitude, _currentLocation.longitude),
            zoom: 17.5),
      ),
    );

    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition:
                    CameraPosition(target: _initialCameraPosition),
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                onMapCreated: _onMapCreated),
            Positioned(
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).size.height * 0.04,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: null,
                        child: Icon(
                          Icons.history,
                          color: Colors.black,
                          size: 25,
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(CircleBorder()),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(15)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _resetToCurrentPosition,
                        child: Icon(
                          Icons.gps_fixed,
                          color: Colors.black,
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(CircleBorder()),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(15)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white),
                    height: 55,
                    width: MediaQuery.of(context).size.width * 0.92,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.directions_walk,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                        Text("Start tracking!"),
                        IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.play_circle_fill,
                            color: Colors.black,
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _checkPermissionAndService() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Location permissions are permantly denied. we cannot request permissions.");
    } else if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            "Location permissions are denied (actual value: $permission).");
      }
    }
  }

  Future<void> _resetToCurrentPosition() async {
    final GoogleMapController controller = await _controller.future;

    //Get current geo-position
    var _currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print(_currentLocation);

    //Create new camera position for maps
    final CameraPosition _newCameraPosition = CameraPosition(
        target: LatLng(_currentLocation.latitude, _currentLocation.longitude),
        zoom: 17.5);

    //Set New Camera Position in maps
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }
}
