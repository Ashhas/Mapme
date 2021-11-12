import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_me/bloc/tracking_footer/tracking_footer_bloc.dart';
import 'package:map_me/ui/widgets/stat_tile_distance.dart';
import 'package:map_me/ui/widgets/stat_tile_speed.dart';
import 'package:map_me/ui/widgets/stat_tile_weather.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TrackingFooterCard extends StatefulWidget {
  final double walkingDistance;
  final double walkingSpeed;

  TrackingFooterCard(
      {required this.walkingDistance, required this.walkingSpeed});

  @override
  _TrackingFooterCardState createState() => _TrackingFooterCardState();
}

class _TrackingFooterCardState extends State<TrackingFooterCard> {
  late StopWatchTimer _stopWatchTimer;
  String currentTime = "00:00:00";

  @override
  void initState() {
    super.initState();
    _setupTimer();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  _setupTimer() {
    _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
      onChange: (value) {
        final displayTime = StopWatchTimer.getDisplayTime(
          value,
          hours: true,
          minute: true,
          second: true,
          milliSecond: false,
        );
        setState(() {
          currentTime = displayTime;
        });
      },
    );
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 195,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: _footerCard(),
          ),
          Positioned(
            bottom: 0,
            child: _closeFooterButton(),
          ),
        ],
      ),
    );
  }

  Widget _footerCard() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      height: 160,
      width: MediaQuery.of(context).size.width * 0.92,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _timerRow(),
          _statsRow(),
        ],
      ),
    );
  }

  Widget _timerRow() {
    return Container(
      height: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.timer,
            color: Colors.black,
            size: 15,
          ),
          Text(
            currentTime,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          StatSpeedTile(title: 'Speed', value: widget.walkingSpeed),
          Container(color: Colors.grey, width: 1.0, height: 40.0),
          StatDistanceTile(title: 'Distance', value: widget.walkingDistance),
          Container(color: Colors.grey, width: 1.0, height: 40.0),
          StatWeatherTile(title: 'Weather'),
        ],
      ),
    );
  }

  Widget _closeFooterButton() {
    return ElevatedButton(
      onPressed: () {
        BlocProvider.of<TrackingFooterBloc>(context).add(
          CloseTrackingFooterCard(),
        );
      },
      child: Icon(
        Icons.close,
        color: Colors.red,
        size: 30,
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(50, 50),
        shape: CircleBorder(),
        primary: Colors.white,
        elevation: 5,
      ),
    );
  }
}
