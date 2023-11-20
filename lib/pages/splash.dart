import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:keneyadememobile/pages/dashboard.dart';

class splash extends StatelessWidget {
  const splash({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Image.asset("assets/images/logokeneya.png"),
          const Text ("Preventions-Senbilisations-Conseils",
          style: TextStyle(fontSize: 21, fontWeight:FontWeight.bold),
          )
        ],
      ), 
      nextScreen: Dashboard(),
      splashIconSize: 200,
      duration:1000,
      splashTransition: SplashTransition.sizeTransition,
      animationDuration: const Duration(seconds: 1),
      
    );
  }
}