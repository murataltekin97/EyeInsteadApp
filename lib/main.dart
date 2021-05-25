import 'package:bitirme_tezi/MySplashPage.dart';
import 'package:flutter/material.dart';
import 'MySplashPage.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eye Instead App',
      home: MySplashPage(),


    );
  }
}
