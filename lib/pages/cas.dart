import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Cas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CasState();
  }
}

class CasItem {
  final int id;
  final String image;
  final DateTime date;

  CasItem({
    required this.id,
    required this.image,
    required this.date,
  });

  factory CasItem.fromJson(Map<String, dynamic> json) {
    return CasItem(
      id: json['id'],
      image: json['image'],
      date: DateTime.parse(json['date']),
    );
  }
}

class CasState extends State<Cas> {
  File? imageFile;
  List<CasItem> casList = [];

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
          if (imageFile != null)
            Container(
              width: double.infinity,
              height: 300,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              padding: EdgeInsets.all(60),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(imageFile!),
                  fit: BoxFit.cover,
                ),
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
            )
          else
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              padding: EdgeInsets.all(60),
              decoration: BoxDecoration(
                color: Colors.white,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(0),
                    ),
                    onPressed: () => getImage(source: ImageSource.camera),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 80,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(0),
                    ),
                    onPressed: () => getImage(source: ImageSource.gallery),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.file_upload,
                          size: 80,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 18),
            child: ElevatedButton(
              onPressed: () {
                if (imageFile != null) {
                  sendCasReport(imageFile!);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Avertissement"),
                        content: Text("Veuillez sélectionner une image."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text("Signaler", style: TextStyle(fontSize: 18)),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: casList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
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
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          color: Colors.grey,
                          child: Image.network(
                            "http://10.0.2.2/" + casList[index].image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        casList[index].date.toString(),
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
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

  void getImage({required ImageSource source}) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      maxHeight: 640,
      maxWidth: 460,
      imageQuality: 10,
    );

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
  void sendCasReport(File image) async {
    try {
      String url = 'http://10.0.2.2:8080/keneya/cas';

      String casString = jsonEncode({"image": image.path});

      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        'cas': casString,
        'image': await MultipartFile.fromFile(
          image.path,
          filename: 'image.jpg',
        ),
      });

      Response response = await dio.post(url, data: formData);

      if (response.statusCode == 201) {
        Map<String, dynamic> responseData = response.data;
        CasItem newCas = CasItem.fromJson(responseData);
        setState(() {
          casList.add(newCas);
          imageFile = null; // Réinitialiser l'image après le signalement réussi
        });
        print('Cas signalé avec succès!');
      } else {
        print('Échec de la requête: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la requête: $e');
    }
  }

}
