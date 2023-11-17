import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Zone extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ZoneState();
  }
}

class ZoneState extends State<Zone> {

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(12.6312102,-8.0327274),
    zoom: 14.4746,
  );

  GoogleMapController? myMapsController;

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
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              myMapsController = controller;
              // myMapsController!.setMapStyle(_mapStyle);
            }, initialCameraPosition: _kGooglePlex,
          ),


        ],
    ),
    );
  }
}
