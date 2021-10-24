import 'package:flutter/material.dart';

class StatTile extends StatefulWidget {
  final String title;
  final double value;

  StatTile({required this.title, required this.value});

  @override
  _StatTileState createState() => _StatTileState();
}

class _StatTileState extends State<StatTile> {
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
