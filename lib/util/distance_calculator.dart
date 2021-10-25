import 'dart:math';
import 'package:geolocator/geolocator.dart';

class DistanceCalculator {
  static double calculate(
      Position firstPosition, Position nextPosition, double currentDistance) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((nextPosition.latitude - firstPosition.latitude) * p) / 2 +
        c(firstPosition.latitude * p) *
            c(nextPosition.latitude * p) *
            (1 - c((nextPosition.longitude - firstPosition.longitude) * p)) /
            2;
    currentDistance += 12742 * asin(sqrt(a));

    return currentDistance;
  }
}
