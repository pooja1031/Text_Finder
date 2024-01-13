import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mobigic/screens/home.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    gotosplash2();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
   
    // ignore: prefer_const_constructors
    final Color customColor = Color.fromRGBO(9, 9, 9, 1);

    return SafeArea(
        child: Scaffold(
      backgroundColor: customColor,
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Column(
          children: [
            DefaultTextStyle(
              style: GoogleFonts.kalam(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.only(top: 128.0, left: 45, right: 40),
                child: AnimatedTextKit(
                    repeatForever: false,
                    totalRepeatCount: 1,
                    animatedTexts: [
                      TyperAnimatedText("welcome",
                          speed:const  Duration(milliseconds: 100))
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 120.0),
              child: Lottie.asset("animations/Animation - 1705097621358.json"),
            ),
          ],
        ),
      ),
    ));
    //   ),
    // );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> gotosplash2() async {
    await Future.delayed(const Duration(seconds: 5));
    // ignore: use_build_context_synchronously
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const MyGridSearchWidget()));
  }
}