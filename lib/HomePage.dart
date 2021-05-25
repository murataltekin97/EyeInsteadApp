import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'main.dart';
import 'package:flutter_tts/flutter_tts.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterTts tts = FlutterTts();
  String result = "";
  bool isWorking = false;
  CameraController cameraController;
  CameraImage imgCamera;


  loadModel() async
  {
    await Tflite.loadModel(
      model: "assets/mobilenet_v1_1.0_224.tflite",
      labels: "assets/mobilenet_v1_1.0_224.txt",
    );
  }

  initCamera()
  {
    cameraController= CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value)
    {
      if(!mounted)
      {
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) =>
        {
          if(!isWorking)
          {
            isWorking = true,
            imgCamera = imageFromStream,
            runModelOnStreamFrames(),

          }

        });
      });

    });

  }
  runModelOnStreamFrames() async
  {
    if(imgCamera != null){
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera.planes.map((plane){
          return plane.bytes;

        }).toList(),
        imageHeight: imgCamera.height,
        imageWidth: imgCamera.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 1,
        threshold: 0.1,
        asynch: true,

      );
      result="";
      recognitions.forEach((response)
      {
        result += response["label"];

      });

      setState(() {
        result;
      });

      isWorking= false;
    }
  }
  @override
  void initState() {

    super.initState();
    loadModel();
  }
  @override
  void dispose() async {

    super.dispose();
    await Tflite.close();
    cameraController?.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/cam2.jpg")
              )
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        color: Colors.black,
                        height: 290, //320,
                        width:  400, //360,
                        child: Image.asset("assets/camera.png"),
                      ),
                    ),
                    Center(
                      child: FlatButton(
                        onPressed: ()
                        {
                          initCamera();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top:35),
                          height: 270,
                          width: 360,
                          child: imgCamera == null
                              ? Container(
                            height: 270,
                            width: 360,
                            //child: Icon(Icons.photo_camera_front, color: Colors.black,size: 400,),
                          )
                              : AspectRatio(
                            aspectRatio: cameraController.value.aspectRatio,
                            child: CameraPreview(cameraController),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 55.0),
                    child: SingleChildScrollView(
                      child: Text(
                        result,
                        style: TextStyle(
                          backgroundColor: Colors.black,
                          fontSize: 40,
                          color: Colors.white,

                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                ),

              ],
            ),
          ),
        ),


      ),

    );
  }
}
