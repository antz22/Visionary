import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visionary/screens/display_result/display_result.dart';
import 'package:visionary/services/text_to_speech.dart';
import 'package:visionary/services/textocr.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({Key? key}) : super(key: key);

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  File? _image;
  List? _output;
  final picker = ImagePicker();

  ocr(File? image) async {
    var output = await TextOCR.run(image!.path);
    List<dynamic> outList = List.from([output['text']]);
    setState(() {
      _output = outList;
    });
    TTS.speak(output['text']);
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    await ocr(_image);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    await ocr(_image);
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
                TTS.speak('Picking Gallery Image to read');
                await pickGalleryImage();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayResultPage(
                      output: _output,
                      image: _image,
                      type: 'Read',
                    ),
                  ),
                );
              },
              child: const Text(
                "SELECT IMAGE TO READ",
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
                TTS.speak('Taking Image from Camera to read');
                await pickImage();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayResultPage(
                      output: _output,
                      image: _image,
                      type: 'Read',
                    ),
                  ),
                );
              },
              child: const Text(
                "TAKE AN IMAGE TO READ",
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
