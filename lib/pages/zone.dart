import 'package:flutter/material.dart';


class Zone extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ZoneState();
  }
}

class ZoneState extends State<Zone> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
          size: 40,
        ),
      ),
      body:Column (
      )
    );
  }
}
