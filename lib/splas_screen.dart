import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';

import 'View/Home/bottom_nav_bar.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 300,
      duration: 1000,
      splashTransition: SplashTransition.sizeTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
      animationDuration: const Duration(seconds: 1),
      backgroundColor: secondary,
      nextScreen: const BottomNavigationScreen(),
      splash: Column(
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: Image.asset("assets/images/row.png"),
          ),
          Text(
            "Tasbeeh & Quran",
            style: TextStyle(
              color: primary,
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
