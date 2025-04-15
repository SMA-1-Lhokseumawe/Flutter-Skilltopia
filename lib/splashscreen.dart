// ignore_for_file: prefer_const_constructors

import 'package:skilltopia/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return AnimatedSplashScreen(
      splash: Container(
        width: screenSize.width,
        height: screenSize.height,
        color: Colors.white,
        child: Stack(
          children: [
            // Top-right curved shape
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: screenSize.width * 0.5,
                height: screenSize.width * 0.5,
                decoration: BoxDecoration(
                  color: Color(0xFF27DEBF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            // Mid-left curved shape
            Positioned(
              top: screenSize.height * 0.3,
              left: -screenSize.width * 0.2,
              child: Container(
                width: screenSize.width * 0.5,
                height: screenSize.width * 0.5,
                decoration: BoxDecoration(
                  color: Color(0xFF27DEBF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo in circular light teal background
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF27DEBF).withOpacity(0.1),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                  
                  SizedBox(height: 30),
                  
                  // App name and subtitle directly below logo
                  Column(
                    children: [
                      Text(
                        'SKILLTOPIA',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 26,
                          letterSpacing: 1.8,
                          color: Color(0xFF27DEBF),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Bank Soal Digital untuk Evaluasi Siswa',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      nextScreen: loginPage(),
      splashIconSize: double.infinity,
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      animationDuration: Duration(milliseconds: 800),
    );
  }
}