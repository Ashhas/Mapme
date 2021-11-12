import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_me/bloc/tracking_footer/tracking_footer_bloc.dart';
import 'package:map_me/ui/widgets/tracking_footer_card.dart';
import 'package:map_me/ui/widgets/tracking_footer_row.dart';
import 'package:map_me/util/constants.dart';
import 'package:map_me/util/distance_calculator.dart';
import 'package:map_me/util/polyline_builder.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? mapStyle;
  double totalDistance = 0.0;
  double walkingSpeed = 0.0;
  Map<PolylineId, Polyline> polylines = {};
  PolylineBuilder polylineBuilder = PolylineBuilder();
  late GoogleMapController googleMapController;
  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    super.initState();
    _getMapStyle();
    _checkPermissionAndService();
  }

  _getMapStyle() {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      rootBundle.loadString("assets/style/map_style.txt").then((string) {
        mapStyle = string;
      });
    });
  }

  _setCurrentCameraPosition(GoogleMapController mapsController) async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _moveCameraPosition(mapsController, currentPosition);
  }

  _moveCameraPosition(
      GoogleMapController mapsController, Position gpsLocation) {
    //Create new camera position for maps
    final CameraPosition _newCameraPosition = CameraPosition(
        target: LatLng(gpsLocation.latitude, gpsLocation.longitude),
        zoom: 17.5);

    //Set New Camera Position in maps
    mapsController
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<TrackingFooterBloc, TrackingFooterState>(
          builder: (BuildContext context, state) {
            return Stack(
              children: [
                GoogleMap(
                  polylines: Set<Polyline>.of(polylines.values),
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: Constants.INITIAL_CAMERA_COORDINATES),
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  onMapCreated: (GoogleMapController internalController) {
                    internalController.setMapStyle(mapStyle);
                    googleMapController = internalController;

                    _setCurrentCameraPosition(googleMapController);
                  },
                ),
                Positioned(
                  left: 15,
                  right: 15,
                  bottom: MediaQuery.of(context).size.height * 0.055,
                  child: BlocListener<TrackingFooterBloc, TrackingFooterState>(
                    listener: (BuildContext context, state) async {
                      if (state is TrackingFooterCardOpenedState) {
                        Position prevPosition =
                            await Geolocator.getCurrentPosition(
                                desiredAccuracy: LocationAccuracy.high);
                        Position currentPosition;

                        //Subscribe to position stream
                        positionStream = Geolocator.getPositionStream()
                            .listen((Position streamPosition) async {
                          //Update current position
                          currentPosition = streamPosition;

                          //Move camera in mapview to the current position
                          _moveCameraPosition(
                              googleMapController, currentPosition);

                          //Set current speed
                          walkingSpeed = currentPosition.speed;

                          //Add poly from mapview
                          polylines = await polylineBuilder.createPolyline(
                              prevPosition, currentPosition);

                          //Calculate total distance
                          totalDistance = DistanceCalculator.calculate(
                              prevPosition, currentPosition, totalDistance);

                          setState(() {});

                          //Create new prev position
                          prevPosition = currentPosition;
                        });
                      } else if (state is TrackingFooterRowOpenedState) {
                        //Unsubscribe to position stream
                        positionStream.cancel();

                        //Clear lines from map
                        polylines.clear();

                        //Clear coordinates in PolylineBuilder
                        polylineBuilder.clear();

                        //Reset Distance
                        totalDistance = 0.0;

                        setState(() {});
                      }
                    },
                    child: BlocBuilder<TrackingFooterBloc, TrackingFooterState>(
                      builder: (BuildContext context, state) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          child: state is TrackingFooterCardOpenedState
                              ? TrackingFooterCard(
                                  walkingDistance: totalDistance,
                                  walkingSpeed: walkingSpeed,
                                )
                              : Column(
                                  children: [
                                    _buttonRow(),
                                    SizedBox(height: 20),
                                    TrackingFooterRow(),
                                  ],
                                ),
                        );
                      },
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buttonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _historyButton(),
        _currentPositionButton(),
      ],
    );
  }

  Widget _historyButton() {
    return ElevatedButton(
      onPressed: () {},
      child: Icon(
        Icons.history,
        color: Colors.black,
        size: 25,
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(CircleBorder()),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(EdgeInsets.all(15)),
      ),
    );
  }

  Widget _currentPositionButton() {
    return ElevatedButton(
      onPressed: () {
        _setCurrentCameraPosition(googleMapController);
      },
      child: Icon(
        Icons.gps_fixed,
        color: Colors.black,
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(CircleBorder()),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(EdgeInsets.all(15)),
      ),
    );
  }
}
