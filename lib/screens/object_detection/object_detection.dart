import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:visionary/screens/display_result/display_result.dart';
import 'package:visionary/services/text_to_speech.dart';
import 'package:visionary/services/textocr.dart';

class ObjectDetectionPage extends StatefulWidget {
  const ObjectDetectionPage({Key? key}) : super(key: key);

  @override
  State<ObjectDetectionPage> createState() => _ObjectDetectionPageState();
}

class _ObjectDetectionPageState extends State<ObjectDetectionPage> {
  File? _image;
  List? _output;
  final picker = ImagePicker();

  loadTfModel() async {
    await Tflite.loadModel(
      model: 'assets/models/object_detection/ssd_mobilenet.tflite',
      labels: 'assets/models/object_detection/labels.txt',
    );
  }

  detectObject(File? image) async {
    var output = await Tflite.detectObjectOnImage(
        path: image!.path, // required
        model: "SSDMobileNet",
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.4, // defaults to 0.1
        numResultsPerClass: 10, // defaults to 5
        asynch: true // defaults to true
        );
    setState(() {
      _output = output;
    });
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    await detectObject(_image);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    await detectObject(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/images/logo.svg'),
        toolbarHeight: 100.0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
      ),
      body: Row(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 10.0),
            width: 0.5 * MediaQuery.of(context).size.width - 15.0,
            height: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              onPressed: () async {
                TTS.speak('Picking Gallery Image to Detect Objects');
                await pickGalleryImage();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayResultPage(
                      output: _output,
                      image: _image,
                    ),
                  ),
                );
              },
              child: const Text(
                "SELECT IMAGE TO DETECT OBJECTS",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 10.0),
            width: 0.5 * MediaQuery.of(context).size.width - 15.0,
            height: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              onPressed: () async {
                TTS.speak('Taking Image from Camera to Detect Objects');
                await pickImage();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayResultPage(
                      output: _output,
                      image: _image,
                    ),
                  ),
                );
              },
              child: const Text(
                "TAKE AN IMAGE TO DETECT OBJECTS",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
