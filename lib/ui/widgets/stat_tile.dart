import 'package:flutter/material.dart';

class StatTile extends StatefulWidget {
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
          "Distance",
          style: TextStyle(
            fontSize: 13,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 2.0),
        Text(
          "--.--",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
