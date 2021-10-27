import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_me/util/constants.dart';

class PolylineBuilder {
  // Id polyline
  PolylineId id = PolylineId('poly');

  // List of coordinates to join
  List<LatLng> polylineCoordinates = [];

  // Holds polyline
  Map<PolylineId, Polyline> polylines = {};

  Future<Map<PolylineId, Polyline>> createPolyline(
      Position start, Position destination) async {
    // Generating the list of coordinates to be used for drawing the polylines
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
      Constants.APIKEY,
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.walking,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      });
    }

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    //Put polyline in map
    polylines[id] = polyline;

    return polylines;
  }

  void clear() {
    polylineCoordinates.clear();
  }
}
