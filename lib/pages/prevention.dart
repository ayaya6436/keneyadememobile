import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:keneyadememobile/pages/methodePrevention.dart';

class Prevention extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PreventionState();
  }
}

class PreventionState extends State<Prevention> {
  bool isPlaying = false;
  bool isLoading = true;

  List<Map<String, dynamic>> filteredMaladiesList = [];
  List<Map<String, dynamic>> maladiesList = [];
  List<MethodePrevention> listRoute = [];


  Future<void> getMaladie() async {
    http.Response response;
    try {
      response = await http.get(Uri.parse("http://10.0.2.2:8080/keneya/maladies"));
      if (response.statusCode == 200) {
        setState(() {
          isLoading=false;
          maladiesList = List<Map<String, dynamic>>.from(json.decode(response.body));
          filteredMaladiesList = List<Map<String, dynamic>>.from(maladiesList);
          // Mettez à jour la liste des routes avec les instances de MethodePrevention
          listRoute = maladiesList.map((maladie) {
            return MethodePrevention(maladieId: maladie['id']);
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
                  "assets/images/prevention.png",
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
                "Preventions",
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
                        builder: (context) => MethodePrevention(maladieId: mapResponse['id']),
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
                    child: Column(
                      children: [
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
