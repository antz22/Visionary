import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:visionary/screens/caption_display/caption_display.dart';
import 'package:visionary/services/text_to_speech.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = false;
  File? _image;
  List? _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  classifyImage(File? image) async {
    var output = await Tflite.runModelOnImage(
      path: image!.path,
      // threhold: 0.0,
      // imageMean: 0,
    );
    print(output);
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(model: 'assets/models/model.tflite');
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    await classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    await classifyImage(_image);
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
            margin: const EdgeInsets.all(5.0),
            color: Colors.green,
            width: MediaQuery.of(context).size.width * 0.5 - 10.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    TTS.speak('Picking Gallery Image');
                    await pickGalleryImage();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CaptionDisplay(
                          output: _output,
                          image: _image,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'SELECT IMAGE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5.0),
            color: Colors.green,
            width: MediaQuery.of(context).size.width * 0.5 - 10.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    TTS.speak('Taking Image with Camera');
                    await pickImage();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CaptionDisplay(
                          output: _output,
                          image: _image,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'TAKE AN IMAGE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
