import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_me/bloc/tracking_footer/tracking_footer_bloc.dart';
import 'package:map_me/ui/widgets/StatTile.dart';

class TrackingFooterCard extends StatefulWidget {
  @override
  _TrackingFooterCardState createState() => _TrackingFooterCardState();
}

class _TrackingFooterCardState extends State<TrackingFooterCard> {
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
    return AnimatedContainer(
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
      // Define how long the animation should take.
      duration: const Duration(seconds: 2),
      // Provide an optional curve to make the animation feel smoother.
      curve: Curves.easeIn,
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
            "--:--",
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
          StatTile(),
          Container(color: Colors.grey, width: 1.0, height: 40.0),
          StatTile(),
          Container(color: Colors.grey, width: 1.0, height: 40.0),
          StatTile(),
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
