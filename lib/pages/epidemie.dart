import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';


class Epidemie extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EpidemieState();
  }
}

String searchTerm = "";
//filter
List<Map<String, dynamic>> filteredEpidemieList = [];
//list epidemie
List<Map<String, dynamic>> epidemiesList = [];
int index = 0;
Map<String, dynamic> mapResponse = {};

class EpidemieState extends State<Epidemie> {

  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isLoading = true; //variable pour indiquer si les données sont en cours de chargement



  Future<void> getEpidemie() async {
    http.Response response;
    try {
      response = await http.get(Uri.parse("http://10.0.2.2:8080/keneya/epidemies"));
      if (response.statusCode == 200) {
        setState(() {
          epidemiesList = List<Map<String, dynamic>>.from(json.decode(response.body));
          mapResponse = epidemiesList[index];
          filteredEpidemieList = List<Map<String, dynamic>>.from(epidemiesList);
          isLoading = false; // Mettez isLoading à false car les données ont été chargées

        });
      }
    } catch (e) {
      print("Erreur lors de la récupération des données : $e");
    }

  }

  Future<void> playAudio(String audioUrl) async {
    if (isPlaying) {
      // Si l'audio est en train de jouer, arrêtez-le
      await audioPlayer.stop();
      setState(() {
        isPlaying = false;
      });
    } else {
      try {
        // Si l'audio ne joue pas, commencez à le jouer
        await audioPlayer.play(UrlSource(audioUrl));
        setState(() {
          isPlaying = true;
        });
      } catch (e) {
        print("Erreur lors de la configuration de l'URL audio : $e");
        return;
      }
    }
  }

  @override
  void initState() {
    getEpidemie();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Image.asset(
                "assets/images/epidemie.png",
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
              "Epidemie",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                var searchTerm = value.toLowerCase();
                filteredEpidemieList = epidemiesList.where((maladie) {
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
        isLoading
            ? CircularProgressIndicator() // Indicateur de chargement pendant le chargement des données
            : Expanded(
            child: ListView.builder(
                itemCount: filteredEpidemieList.length,
                itemBuilder: (context, index) {
                  mapResponse = filteredEpidemieList[index];
                  String audioUrl = mapResponse['audio'];
                  mapResponse = epidemiesList[index];
         return  Container(
           margin: EdgeInsets.symmetric(vertical: 10,horizontal: 24),
           decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.only(
                 topLeft: Radius.circular(10),
                 topRight: Radius.circular(10),
                 bottomLeft: Radius.circular(10),
                 bottomRight: Radius.circular(10)
             ),

             boxShadow: [
               BoxShadow(
                 color: Colors.grey.withOpacity(0.5),
                 spreadRadius: 2,
                 blurRadius: 7,
                 offset: Offset(0, 0), // changes position of shadow
               ),
             ],
           ),
           padding: EdgeInsets.all(20),
             child: Column(
               children: [
                 Row(
                   // mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     Text(
                       mapResponse['nom'].toString(),
                       style: TextStyle(
                         fontSize: 20,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     IconButton(
                     onPressed: () {
                     playAudio(audioUrl);
                     },
                     icon: Icon(Icons.play_circle, color: Colors.blue)),
                   ],
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [

                     Text(
                       "Status :",
                       style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),),
                     SizedBox(width: 10),
                     Text( mapResponse['status'].toString(),style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                         color:Colors.red
                     ),),
                   ],
                 ),
                 SizedBox(height: 10),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [

                     Text("Gravite :",
                       style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),),
                     SizedBox(width: 10),
                     Text( mapResponse['gravite'].toString() ,style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                         color:Colors.red
                     ),),
                   ],
                 ),

                 SizedBox(height: 10),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [

                     Text("Victimes :",
                       style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),),
                     SizedBox(width: 10),
                     Text( mapResponse['victimes'].toString(),style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                         color:Colors.red
                     ),),
                   ],
                 ),
               ],
             ),
         );
       }),
          )
      ]),
    );
  }
}
