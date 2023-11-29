import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

class MethodePrevention extends StatefulWidget {
  final int maladieId;

  MethodePrevention({required this.maladieId});

  @override
  State<StatefulWidget> createState() {
    return MethodePreventionState(maladieId: maladieId);
  }
}


//filter
List<Map<String, dynamic>> filteredMethodesList = [];
//plier deplier
List<bool> isExpandedList = [];
//list maladie
List<Map<String, dynamic>> methodeList = [];
int index = 0;
Map<String, dynamic> mapResponse = {};

class MethodePreventionState extends State<MethodePrevention>{
  int maladieId;

  MethodePreventionState({required this.maladieId});
  bool isLoading = true;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  List imageList = [
    {"id": 1, "image_path": 'assets/images/prevention1.jpg'},
    {"id": 2, "image_path": 'assets/images/slide1.png'},
  ];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  Future<void> getMethode(int maladieId) async {
    http.Response response;

    try {
      response = await http.get(Uri.parse("http://10.0.2.2:8080/keneya/preventions/maladie/$maladieId"));
      if (response.statusCode == 200) {
        setState(() {
          methodeList = List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(response.bodyBytes)));
          mapResponse = methodeList[index];
          isExpandedList = List.generate(methodeList.length, (index) => false);
          isLoading = false;
          filteredMethodesList = List<Map<String, dynamic>>.from(methodeList);
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
        // Ajoutez 10.0.2.2 à l'URL audio
        audioUrl = "http://10.0.2.2/" + audioUrl;

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
    getMethode(widget.maladieId);
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

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0), // Ajuste la marge selon tes besoins
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    print(currentIndex);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CarouselSlider(
                      items: methodeList
                          .map(
                            (item) => Image.network(
                          "http://10.0.2.2/" + item['image'], // Utilisez le chemin de l'image de chaque méthode
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                          .toList(),
                      carouselController: carouselController,
                      options: CarouselOptions(
                        scrollPhysics: const BouncingScrollPhysics(),
                        autoPlay: true,
                        aspectRatio: 2,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imageList.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => carouselController.animateToPage(entry.key),
                        child: Container(
                          width: currentIndex == entry.key ? 17 : 7,
                          height: 7.0,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 3.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: currentIndex == entry.key
                                ? Colors.red
                                : Colors.teal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Methodes de preventions",
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
                  filteredMethodesList = methodeList.where((methode) {
                    return methode['nom'].toLowerCase().contains(searchTerm);
                  }).toList();
                });
              },
              decoration: InputDecoration(
                labelText: "Rechercher",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),isLoading
              ? CircularProgressIndicator() // Indicateur de chargement pendant le chargement des données
              : Expanded(
            child: ListView.builder(
              itemCount: filteredMethodesList.length,
              itemBuilder: (context, index) {
                mapResponse = filteredMethodesList[index];
                // mapResponse = methodeList[index];
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