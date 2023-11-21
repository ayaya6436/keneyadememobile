

import 'package:flutter/material.dart';

class Cas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CasState();
  }
}

class CasState extends State<Cas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
          size: 40,
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Image.asset(
                  "assets/images/zoneDanger.png",
                  width: 188,
                  height: 169,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Signaler cas",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            padding: EdgeInsets.all(60), // Adjusted padding value
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: ElevatedButton(
           style: ButtonStyle(
             backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey),
               elevation: MaterialStateProperty.all<double>(0)
           ),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 18),
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Signaler", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
