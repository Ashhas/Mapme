import 'package:flutter/material.dart';

class StatSpeedTile extends StatefulWidget {
  final String title;
  final double value;

  StatSpeedTile({required this.title, required this.value});

  @override
  _StatSpeedTileState createState() => _StatSpeedTileState();
}

class _StatSpeedTileState extends State<StatSpeedTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 2.0),
        Text(
          "${widget.value.toStringAsFixed(2)} m/s",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
