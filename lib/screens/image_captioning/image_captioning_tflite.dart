import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:visionary/screens/display_result/display_result.dart';
import 'package:visionary/services/text_to_speech.dart';

class ImageCaptioningPage extends StatefulWidget {
  const ImageCaptioningPage({Key? key}) : super(key: key);

  @override
  State<ImageCaptioningPage> createState() => _ImageCaptioningPageState();
}

class _ImageCaptioningPageState extends State<ImageCaptioningPage> {
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
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 10.0),
            width: 0.5 * MediaQuery.of(context).size.width - 15.0,
            height: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              onPressed: () async {
                TTS.speak('Picking Gallery Image to caption it');
                await pickGalleryImage();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayResultPage(
                      output: _output,
                      image: _image,
                      type: 'Image Captioning',
                    ),
                  ),
                );
              },
              child: const Text(
                "SELECT IMAGE TO CAPTION IMAGE",
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
                TTS.speak('Taking Image from Camera to Caption Image');
                await pickImage();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayResultPage(
                      output: _output,
                      image: _image,
                      type: 'Image Captioning',
                    ),
                  ),
                );
              },
              child: const Text(
                "TAKE AN IMAGE TO CAPTION IT",
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
