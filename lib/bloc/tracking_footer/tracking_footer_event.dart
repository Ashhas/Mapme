part of 'tracking_footer_bloc.dart';

@immutable
abstract class TrackingFooterEvent extends Equatable {
  const TrackingFooterEvent();
}

class HomeOpened extends TrackingFooterEvent {
  @override
  List<Object> get props => [];
}

class OpenTrackingFooterCard extends TrackingFooterEvent {
  @override
  List<Object> get props => [];
}

class ResetToCurrentLocation extends TrackingFooterEvent {
  @override
  List<Object> get props => [];
}

class CloseTrackingFooterCard extends TrackingFooterEvent {
  @override
  List<Object> get props => [];
}
