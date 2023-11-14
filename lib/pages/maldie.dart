import 'package:flutter/material.dart';

class Maladie extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MaladieState();
  }
}

class MaladieState extends State<Maladie> {
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

        Expanded(
          child: ListView.builder(
            itemCount: 5,
              itemBuilder: (context,index){
            return Container(
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
                child:Column(
                  children: [
                    Text("Paludisme",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(onPressed: (){}, icon: Icon(Icons.play_circle,color: Colors.blue,)),
                    Text("jdklasmkdlkjjskdajkdjkjkakjsjkdjksahkdjahjjkewoasdopodsksadjjsdakkkkkkkkkkkkkkkkkkkkkkaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
                    Container(
                      width: double.infinity,
                      child: TextButton(
                          style:TextButton.styleFrom( backgroundColor: Colors.blue),
                          onPressed: (){}, child: Text("Voir plus",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:Colors.white
                          )
                      )
                      ),
                    )
                  ],
                )
            );
          }),
        )
      ]),
    );
  }
}
