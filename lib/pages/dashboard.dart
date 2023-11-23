import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:keneyadememobile/pages/annonce.dart';
import 'package:keneyadememobile/pages/calendrier.dart';
import 'package:keneyadememobile/pages/cas.dart';
import 'package:keneyadememobile/pages/epidemie.dart';
import 'package:keneyadememobile/pages/forum.dart';
import 'package:keneyadememobile/pages/maldie.dart';
import 'package:keneyadememobile/pages/prevention.dart';
import 'package:keneyadememobile/pages/traitement.dart';
import 'package:keneyadememobile/pages/zone.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
   List imageList = [
    {"id": 1, "image_path": 'assets/images/prevention1.jpg'},
    {"id": 2, "image_path": 'assets/images/slide1.png'},
  ];

   List imgCard =[
     "assets/images/maladie.png",
     "assets/images/epidemie.png",
     "assets/images/prevention.png",
     "assets/images/traitement.png",
     "assets/images/zone.png",
     "assets/images/calendrier.png",
     "assets/images/megaphone.png",
     "assets/images/zoneDanger.png",
     "assets/images/forum.png",
   ];


   List cardTitles=[
     "Maladies",
     "Epidemies",
     "Preventions",
     "Traitements",
     "Zones",
     "Calendrier",
     "Annonces",
     "Signaler Cas",
     "Forum",
   ];


   List<Widget> listRoute = [
     Maladie(),
     Epidemie(),
     Prevention(),
     Traitement(),
     Zone(),
     Calendrier(),
     Annonce(),
     Cas(),
     Forum()

   ];
    final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          SizedBox(height: 52),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Image.asset(
                  "assets/images/logokeneya.png",
                  width: 162,
                  height: 42,
                ),
              ),
            ],
          ),
          SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.all(5.0), // Ajuste la marge selon tes besoins
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    print(currentIndex);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15), // Ajuste selon tes besoins
                    child: CarouselSlider(
                      items: imageList
                          .map(
                            (item) => Image.asset(
                              item['image_path'],
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
         GridView.builder(
           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: 3,
             childAspectRatio: 1.1,
             crossAxisSpacing: 0,
           ),
           shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
           itemCount: imgCard.length,
           itemBuilder: (context,index){
             return InkWell(
               onTap: (){
                 Navigator.push(context,MaterialPageRoute(builder: (context)=>listRoute[index]));
               },
               child: Container(
                 margin: EdgeInsets.all(10),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(10),
                   color: Colors.white,
                   boxShadow: [
                     BoxShadow(
                       color: Colors.black26,
                       spreadRadius: 1,
                       blurRadius: 2
                     )
                   ]
                 ),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children:[
                     Image.asset(imgCard[index],
                     width: 60,),
                     Text(cardTitles[index],
                       style: TextStyle(
                         fontSize: 16,
                         fontWeight: FontWeight.bold
                       )
                     ),
                   ]
                 ),
               ),
             );
           },
          )
        ],
      ),

    );
  }
}