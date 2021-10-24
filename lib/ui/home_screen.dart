import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_me/bloc/tracking_footer/tracking_footer_bloc.dart';
import 'package:map_me/ui/widgets/tracking_footer_card.dart';
import 'package:map_me/ui/widgets/tracking_footer_row.dart';
import 'package:map_me/util/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _mapStyle;
  Set<Marker> markers = {};
  double totalDistance = 0.0;
  double walkingSpeed = 0.0;
  late GoogleMapController googleMapController;
  late StreamSubscription<Position> positionStream;
  LatLng _initialCameraPosition = LatLng(20.5937, 78.9629);

  // List of coordinates to join
  List<LatLng> polylineCoordinates = [];

  // Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polylines = {};

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
                  polylines: Set<Polyline>.of(polylines.values),
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
                  bottom: MediaQuery.of(context).size.height * 0.055,
                  child: BlocListener<TrackingFooterBloc, TrackingFooterState>(
                    listener: (BuildContext context, state) async {
                      if (state is TrackingFooterCardOpenedState) {
                        Position prevPosition = await _getCurrentPosition();
                        Position currentPosition;

                        //Subscribe to position stream
                        positionStream = Geolocator.getPositionStream()
                            .listen((Position position) {
                          //Update Current Position
                          currentPosition = position;

                          //Set Camera in mapview
                          googleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                  target: LatLng(
                                      position.latitude, position.longitude),
                                  zoom: 17.5),
                            ),
                          );

                          //Update state to show line on map
                          //TODO: Implement BloC state to update the lines
                          setState(() {
                            //Set Current Speed
                            walkingSpeed = currentPosition.speed;

                            //Create Polylines in mapview
                            _createPolylines(prevPosition, currentPosition);

                            //Calculate distance
                            _calculateDistance(prevPosition, currentPosition);
                          });

                          // Replace prev position with new one
                          prevPosition = currentPosition;
                        });
                      } else if (state is TrackingFooterRowOpenedState) {
                        //Unsubscribe to position stream
                        positionStream.cancel();

                        //Clear lines from map
                        polylines.clear();

                        //Clear Distance
                        totalDistance = 0.0;
                      }
                    },
                    child: BlocBuilder<TrackingFooterBloc, TrackingFooterState>(
                      builder: (BuildContext context, state) {
                        if (state is TrackingFooterCardOpenedState) {
                          return TrackingFooterCard(
                            walkingDistance: totalDistance,
                            walkingSpeed: walkingSpeed,
                          );
                        } else {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _historyButton(),
                                  _currentPositionButton(),
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

  Widget _historyButton() {
    return ElevatedButton(
      onPressed: null,
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
        _setCameraToCurrentPosition(googleMapController);
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

  Future<void> _onMapCreated(GoogleMapController controller) async {
    controller.setMapStyle(_mapStyle);
    googleMapController = controller;

    _setCameraToCurrentPosition(googleMapController);
  }

  Future<Position> _getCurrentPosition() {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  _setCameraToCurrentPosition(GoogleMapController controller) async {
    //Get current geo-position
    Position currentPosition = await _getCurrentPosition();

    //Create new camera position for maps
    final CameraPosition _newCameraPosition = CameraPosition(
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
        zoom: 17.5);

    //Set New Camera Position in maps
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  _calculateDistance(Position firstPosition, Position nextPosition) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((nextPosition.latitude - firstPosition.latitude) * p) / 2 +
        c(firstPosition.latitude * p) *
            c(nextPosition.latitude * p) *
            (1 - c((nextPosition.longitude - firstPosition.longitude) * p)) /
            2;
    totalDistance += 12742 * asin(sqrt(a));
  }

  _createPolylines(Position start, Position destination) async {
    //Initializing PolylinePoints
    PolylinePoints polylinePoints = PolylinePoints();

    //Generating the list of coordinates to be used for drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Constants.APIKEY,
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.walking,
    );

    //Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      });
    }

    //Defining an ID
    PolylineId id = PolylineId('poly');

    //Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    //Adding the polyline to the map
    polylines[id] = polyline;
  }
}
