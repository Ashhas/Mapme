import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tracking_footer_event.dart';

part 'tracking_footer_state.dart';

class TrackingFooterBloc
    extends Bloc<TrackingFooterEvent, TrackingFooterState> {
  TrackingFooterBloc() : super(TrackingFooterInitState());

  @override
  Stream<TrackingFooterState> mapEventToState(
      TrackingFooterEvent event) async* {
    if (event is HomeOpened) {
      yield* _mapHomeOpened();
    } else if (event is ResetToCurrentLocation) {
      yield* _mapResetToCurrentLocation(event.googleMapController);
    } else if (event is OpenTrackingFooterCard) {
      yield* _mapOpenTrackingFooterCard();
    } else if (event is CloseTrackingFooterCard) {
      yield* _mapCloseTrackingFooterCard();
    }
  }

  Stream<TrackingFooterState> _mapHomeOpened() async* {
    yield HomeOpenedState();
  }

  Stream<TrackingFooterState> _mapResetToCurrentLocation(
      GoogleMapController? mapController) async* {
    print("Reset");

    //Get current geo-position
    var _currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //Create new camera position for maps
    final CameraPosition _newCameraPosition = CameraPosition(
        target: LatLng(_currentLocation.latitude, _currentLocation.longitude),
        zoom: 17.5);

    //Set New Camera Position in maps
    mapController!
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  Stream<TrackingFooterState> _mapOpenTrackingFooterCard() async* {
    yield TrackingFooterCardOpenedState();
  }

  Stream<TrackingFooterState> _mapCloseTrackingFooterCard() async* {
    yield TrackingFooterRowOpenedState();
  }
}
