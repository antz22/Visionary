import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:visionary/screens/image_captioning/display_caption.dart';
import 'package:visionary/services/text_to_speech.dart';

class ImageCaptioningPage extends StatefulWidget {
  const ImageCaptioningPage({Key? key}) : super(key: key);

  @override
  State<ImageCaptioningPage> createState() => _ImageCaptioningPageState();
}

class _ImageCaptioningPageState extends State<ImageCaptioningPage> {
  File? _image;
  List? _output;
  final picker = ImagePicker();

  final String uploadUrl = "http://172.16.4.171:8000/api";
  final String downloadUrl = "http://172.16.4.171:8000/result";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  uploadImage(File? image) async {
    String base64Image = base64Encode(image!.readAsBytesSync());
    Response response = await Dio().post(uploadUrl, data: base64Image);
    print(response.data);
    setState(() {
      _output = [response.data];
    });
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    await uploadImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    await uploadImage(_image);
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
                    builder: (context) => DisplayCaptionPage(
                      output: _output,
                      image: _image,
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
                    builder: (context) => DisplayCaptionPage(
                      output: _output,
                      image: _image,
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
