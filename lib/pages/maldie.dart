import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

class Maladie extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MaladieState();
  }
}

//filter
List<Map<String, dynamic>> filteredMaladiesList = [];

//plier deplier
List<bool> isExpandedList = [];
//list maladie
List<Map<String, dynamic>> maladiesList = [];
int index = 0;
Map<String, dynamic> mapResponse = {};

class MaladieState extends State<Maladie> {
  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> getMaladie() async {
    http.Response response;
    try {
      response = await http.get(Uri.parse("http://10.0.2.2:8080/keneya/maladies"));
      if (response.statusCode == 200) {
        setState(() {
          maladiesList = List<Map<String, dynamic>>.from(json.decode(response.body));
          mapResponse = maladiesList[index];
          isExpandedList = List.generate(maladiesList.length, (index) => false);
          filteredMaladiesList = List<Map<String, dynamic>>.from(maladiesList);
        });
      }
    } catch (e) {
      print("Erreur lors de la récupération des données : $e");
    }

  }

  Future<void> playAudio(String audioUrl) async {
   await audioPlayer.play(audioUrl as Source);
  }

  @override
  void initState() {
    getMaladie();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  "assets/images/maladie.png",
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
                "Maladies",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  var searchTerm = value.toLowerCase();
                  filteredMaladiesList = maladiesList.where((maladie) {
                    return maladie['nom'].toLowerCase().contains(searchTerm);
                  }).toList();
                });
              },

              decoration: InputDecoration(
                labelText: "Rechercher",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMaladiesList.length,
              itemBuilder: (context, index) {
                mapResponse = filteredMaladiesList[index];
                mapResponse = maladiesList[index];
                String audioUrl = mapResponse['audio'];
                bool isExpanded = isExpandedList[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        mapResponse['nom'].toString(),
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          playAudio(audioUrl);
                        },
                        icon: Icon(Icons.play_circle, color: Colors.blue),
                      ),
                      Text(
                        mapResponse['description'].toString(),
                        maxLines: isExpanded ? null : 3,
                      ),
                      Container(
                        width: double.infinity,
                        child: TextButton(
                          style: TextButton.styleFrom(backgroundColor: Colors.blue),
                          onPressed: () {
                            setState(() {
                              isExpandedList[index] = !isExpandedList[index];
                            });
                          },
                          child: Text(
                            "Voir plus",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
