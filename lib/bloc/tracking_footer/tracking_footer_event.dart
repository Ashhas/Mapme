part of 'tracking_footer_bloc.dart';

@immutable
abstract class TrackingFooterEvent extends Equatable {
  const TrackingFooterEvent();
}

class OpenTrackingFooterCard extends TrackingFooterEvent {
  @override
  List<Object> get props => [];
}

class CloseTrackingFooterCard extends TrackingFooterEvent {
  @override
  List<Object> get props => [];
}
