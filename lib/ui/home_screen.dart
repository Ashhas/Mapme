import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  String _mapStyle = '';

  static final CameraPosition _kInitialLocation = CameraPosition(
    target: LatLng(52.29435148497498, 4.960703197502028),
    zoom: 14.4746,
  );

  static final CameraPosition _kSchool = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(52.35589235898195, 4.955131805759462),
      zoom: 15);

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      rootBundle.loadString("assets/style/map_style.txt").then((string) {
        _mapStyle = string;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kInitialLocation,
            buildingsEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              controller.setMapStyle(_mapStyle);
              _controller.complete(controller);
            },
          ),
          Positioned(
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).size.height * 0.03,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), color: Colors.white),
              height: 55,
              width: MediaQuery.of(context).size.width * 0.92,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.directions_walk,
                      color: Colors.black,
                    ),
                  ),
                  Text("Start tracking!"),
                  IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.play_circle_fill,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kSchool));
  }
}
