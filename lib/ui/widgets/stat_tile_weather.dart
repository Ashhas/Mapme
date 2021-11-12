import 'package:flutter/material.dart';

class StatWeatherTile extends StatefulWidget {
  final String title;

  StatWeatherTile({required this.title});

  @override
  _StatDistanceTileState createState() => _StatDistanceTileState();
}

class _StatDistanceTileState extends State<StatWeatherTile> {
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
          "---",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
