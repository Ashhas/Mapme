import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_me/bloc/tracking_footer/tracking_footer_bloc.dart';

class TrackingFooterRow extends StatefulWidget {
  @override
  _TrackingFooterRowState createState() => _TrackingFooterRowState();
}

class _TrackingFooterRowState extends State<TrackingFooterRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: Colors.white),
      height: 55,
      width: MediaQuery.of(context).size.width * 0.90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            padding: EdgeInsets.only(left: 15),
            onPressed: () {
              BlocProvider.of<TrackingFooterBloc>(context).add(
                CloseTrackingFooterCard(),
              );
            },
            icon: Icon(
              Icons.directions_walk,
              color: Colors.black,
              size: 20,
            ),
          ),
          Text("Start tracking!"),
          IconButton(
            padding: EdgeInsets.only(right: 15),
            onPressed: () {
              BlocProvider.of<TrackingFooterBloc>(context).add(
                OpenTrackingFooterCard(),
              );
            },
            icon: Icon(
              Icons.play_circle_fill,
              color: Colors.black,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
