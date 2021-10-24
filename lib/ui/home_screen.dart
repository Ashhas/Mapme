import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_me/bloc/tracking_footer/tracking_footer_bloc.dart';
import 'package:map_me/ui/widgets/TrackingFooterCard.dart';
import 'package:map_me/ui/widgets/TrackingFooterRow.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController googleMapController;
  late StreamSubscription<Position> positionStream;
  LatLng _initialCameraPosition = LatLng(20.5937, 78.9629);
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    _getMapStyle();
    _checkPermissionAndService();
  }

  _getMapStyle() {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      rootBundle.loadString("assets/style/map_style.txt").then((string) {
        _mapStyle = string;
      });
    });
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
                  mapType: MapType.normal,
                  initialCameraPosition:
                      CameraPosition(target: _initialCameraPosition),
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                ),
                Positioned(
                  left: 15,
                  right: 15,
                  bottom: MediaQuery.of(context).size.height * 0.06,
                  child: BlocListener<TrackingFooterBloc, TrackingFooterState>(
                    listener: (BuildContext context, state) {
                      if (state is TrackingFooterCardOpenedState) {
                        positionStream = Geolocator.getPositionStream()
                            .listen((Position position) {
                          googleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                  target: LatLng(
                                      position.latitude, position.longitude),
                                  zoom: 17.5),
                            ),
                          );
                        });
                      } else if (state is TrackingFooterRowOpenedState) {
                        positionStream.cancel();
                      }
                    },
                    child: BlocBuilder<TrackingFooterBloc, TrackingFooterState>(
                      builder: (BuildContext context, state) {
                        if (state is TrackingFooterCardOpenedState) {
                          return TrackingFooterCard();
                        } else {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: null,
                                    child: Icon(
                                      Icons.history,
                                      color: Colors.black,
                                      size: 25,
                                    ),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          CircleBorder()),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(15)),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _setMapCameraCurrentPosition(
                                          googleMapController);
                                    },
                                    child: Icon(
                                      Icons.gps_fixed,
                                      color: Colors.black,
                                    ),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          CircleBorder()),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(15)),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              TrackingFooterRow(),
                            ],
                          );
                        }
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

  Future<void> _onMapCreated(GoogleMapController controller) async {
    controller.setMapStyle(_mapStyle);
    googleMapController = controller;

    _setMapCameraCurrentPosition(googleMapController);
  }

  _setMapCameraCurrentPosition(GoogleMapController controller) async {
    //Get current geo-position
    var currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //Create new camera position for maps
    final CameraPosition _newCameraPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 17.5);

    //Set New Camera Position in maps
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }
}
