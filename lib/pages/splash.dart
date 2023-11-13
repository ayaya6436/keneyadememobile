import 'package:flutter/material.dart';
import 'package:keneyadememobile/pages/dashboard.dart';
import 'package:lottie/lottie.dart';
class splash extends StatefulWidget {


  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> with TickerProviderStateMixin{
  late final AnimationController _controller;


  @override
  void initState(){
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
        Lottie.network("https://assets3.lottiefiles.com/packages/lf20_AMBEWz.json",
        controller: _controller,
        onLoaded: (compos){
          _controller
          ..duration = compos.duration
          ..forward().then((value){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard())
            );
          });
        }
        ),
        Center(
        child: Text("Preventions-Traitements-Conseils")
        )
        ]
      ),
    );
  }
}