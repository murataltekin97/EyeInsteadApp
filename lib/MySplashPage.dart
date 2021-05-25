import 'package:bitirme_tezi/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'main.dart';

import 'package:flutter_tts/flutter_tts.dart';

class MySplashPage extends StatefulWidget {
  @override
  _MySplashPageState createState() => _MySplashPageState();
}

class _MySplashPageState extends State<MySplashPage> {
  final FlutterTts tts = FlutterTts();
  Future<void> speak() async
  {
    await tts.setLanguage("tr-TR");
    await tts.setPitch(1);
    await tts.speak("Uygulama başlatılıyor lütfen bekleyiniz.");

  }

  @override
  Widget build(BuildContext context) {

    return SplashScreen(
      seconds: 10,
      navigateAfterSeconds: HomePage(),
      imageBackground: Image.asset("assets/new1.png").image,
      useLoader: true,
      loaderColor: Colors.blue,
      loadingText: Text("LOADING..."),







    );
  }
}
