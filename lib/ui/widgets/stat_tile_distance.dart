import 'package:flutter/material.dart';

class StatDistanceTile extends StatefulWidget {
  final String title;
  final double value;

  StatDistanceTile({required this.title, required this.value});

  @override
  _StatDistanceTileState createState() => _StatDistanceTileState();
}

class _StatDistanceTileState extends State<StatDistanceTile> {
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
          "${widget.value.toStringAsFixed(2)} km",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
