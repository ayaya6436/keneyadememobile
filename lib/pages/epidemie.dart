import 'package:flutter/material.dart';

class Epidemie extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EpidemieState();
  }
}

class EpidemieState extends State<Epidemie> {
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

          Expanded(
            child: ListView.builder(
            itemCount:3,
                itemBuilder:(context,index){
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
                       "Nom Epidemie",
                       style: TextStyle(
                         fontSize: 20,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     IconButton(
                         onPressed: () {},
                         icon: Icon(
                           Icons.play_circle,
                           color: Colors.blue,
                         )),
                   ],
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [

                     Text("Status :",
                       style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),),
                     SizedBox(width: 10),
                     Text("En cours" ,style: TextStyle(
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
                     Text("Forte" ,style: TextStyle(
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
                     Text("1234" ,style: TextStyle(
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
