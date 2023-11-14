import 'package:flutter/material.dart';

class Calendrier extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CalendrierState();
  }
  
}
class CalendrierState extends State<Calendrier>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
          size: 40,
        ),
      ),
      body: Text("Calendrier"),
    );
  }
  
}