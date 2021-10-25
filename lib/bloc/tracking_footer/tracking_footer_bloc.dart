import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    if (event is OpenTrackingFooterCard) {
      yield* _mapOpenTrackingFooterCard();
    } else if (event is CloseTrackingFooterCard) {
      yield* _mapCloseTrackingFooterCard();
    }
  }

  Stream<TrackingFooterState> _mapOpenTrackingFooterCard() async* {
    yield TrackingFooterCardOpenedState();
  }

  Stream<TrackingFooterState> _mapCloseTrackingFooterCard() async* {
    yield TrackingFooterRowOpenedState();
  }
}
