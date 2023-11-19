import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class ZoneModel {
  final int id;
  final String nom;
  final String longitude;
  final String latitude;

  ZoneModel({
    required this.id,
    required this.nom,
    required this.longitude,
    required this.latitude,
  });

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
      id: json['id'],
      nom: json['nom'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
}

class Zone extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ZoneState();
  }
}

class ZoneState extends State<Zone> {
  late GoogleMapController mapController;
  List<Marker> markers = [];

  final LatLng _center = const LatLng(12.67171,-7.89541);

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    try {
      List<ZoneModel> zones = await fetchZones();
      _addMarkers(zones);
    } catch (e) {
      // Gestion des erreurs (affichage d'un message d'erreur, par exemple)
    }
  }

  Future<List<ZoneModel>> fetchZones() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:8080/keneya/zones"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((zoneData) => ZoneModel.fromJson(zoneData)).toList();
    } else {
      throw Exception('Failed to load zones');
    }
  }

  void _addMarkers(List<ZoneModel> zones) {
    setState(() {
      markers = zones.map((zone) {
        return Marker(
          markerId: MarkerId(zone.id.toString()),
          position: LatLng(double.parse(zone.latitude), double.parse(zone.longitude)),
          infoWindow: InfoWindow(
            title: zone.nom,
            // Ajoutez d'autres détails de description si nécessaire.
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
      }).toList();
    });
  }

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
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: Set.from(markers),
      ),
    );
  }
}
