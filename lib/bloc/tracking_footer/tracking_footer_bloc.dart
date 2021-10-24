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
      yield* _mapResetToCurrentLocation();
    } else if (event is OpenTrackingFooterCard) {
      yield* _mapOpenTrackingFooterCard();
    } else if (event is CloseTrackingFooterCard) {
      yield* _mapCloseTrackingFooterCard();
    }
  }

  Stream<TrackingFooterState> _mapHomeOpened() async* {
    yield HomeOpenedState();
  }

  Stream<TrackingFooterState> _mapResetToCurrentLocation() async* {}

  Stream<TrackingFooterState> _mapOpenTrackingFooterCard() async* {
    yield TrackingFooterCardOpenedState();
  }

  Stream<TrackingFooterState> _mapCloseTrackingFooterCard() async* {
    yield TrackingFooterRowOpenedState();
  }
}
