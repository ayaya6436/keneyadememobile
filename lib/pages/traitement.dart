import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:keneyadememobile/pages/methodeTraitement.dart';

class Traitement extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TraitementState();
  }

}


class TraitementState extends State<Traitement>{
  bool isLoading = true;
  List<Map<String, dynamic>> filteredMaladiesList = [];
  List<Map<String, dynamic>> maladiesList = [];
  List<MethodeTraitement> listRoute = [];

  Future<void> getMaladie() async {
    http.Response response;
    try {
      response = await http.get(Uri.parse("http://10.0.2.2:8080/keneya/maladies"));
      if (response.statusCode == 200) {
        setState(() {
          maladiesList = List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(response.bodyBytes)));
          filteredMaladiesList = List<Map<String, dynamic>>.from(maladiesList);
          isLoading = false;
          // Mettez à jour la liste des routes avec les instances de MethodePrevention
          listRoute = maladiesList.map((maladie) {
            return MethodeTraitement(maladieId: maladie['id']);
          }).toList();
        });
      }
    } catch (e) {
      print("Erreur lors de la récupération des données : $e");
    }
  }

  @override
  void initState() {
    getMaladie();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Image.asset(
                  "assets/images/traitement.png",
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
                "Traitements",
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
          ),isLoading
              ? CircularProgressIndicator() // Indicateur de chargement pendant le chargement des données
              :Expanded(
            child: ListView.builder(
              itemCount: filteredMaladiesList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> mapResponse = filteredMaladiesList[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MethodeTraitement(maladieId: mapResponse['id']),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 2,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(

                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10), // ou ajustez selon vos besoins
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            color: Colors.grey, // couleur de fond du conteneur
                            child: Image.network(
                              "http://10.0.2.2/" + mapResponse['image'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover, // assure que l'image couvre complètement le conteneur
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text(
                          mapResponse['nom'].toString(),
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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