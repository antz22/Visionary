import 'package:flutter/material.dart';
import 'package:visionary/constants/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:visionary/screens/image_captioning/image_captioning.dart';
import 'package:visionary/screens/object_detection/object_detection.dart';
import 'package:visionary/screens/read/read_page.dart';
import 'package:visionary/services/text_to_speech.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 0.05 * MediaQuery.of(context).size.height),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(
              horizontal: 2 * kDefaultPadding,
              vertical: 2 * kDefaultPadding,
            ),
            child: SvgPicture.asset('assets/images/logo.svg'),
          ),
          SizedBox(
            width: 0.925 * MediaQuery.of(context).size.width, // <-- Your width
            height: 0.3 * MediaQuery.of(context).size.height, // <-- Your height
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              onPressed: () {
                TTS.speak(
                    'Scanning to read. Click left side to select image from photo gallery, click right side to take photo with camera.');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReadPage(),
                  ),
                );
              },
              child: const Text(
                "Tap to Read",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ),
          SizedBox(height: 0.025 * MediaQuery.of(context).size.width),
          Row(children: [
            SizedBox(
              width: 0.0375 * MediaQuery.of(context).size.width,
            ),
            SizedBox(
              width: 0.45 * MediaQuery.of(context).size.width, // <-- Your width
              height:
                  0.4 * MediaQuery.of(context).size.height, // <-- Your height
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                onPressed: () {
                  TTS.speak(
                      'Object detection. Click left side to select image from photo gallery, click right side to take photo with camera.');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ObjectDetectionPage(),
                    ),
                  );
                },
                child: const Text(
                  "Tap to Identify Objects",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 0.025 * MediaQuery.of(context).size.width,
            ),
            SizedBox(
              width: 0.45 * MediaQuery.of(context).size.width, // <-- Your width
              height:
                  0.4 * MediaQuery.of(context).size.height, // <-- Your height
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                onPressed: () {
                  TTS.speak(
                      'Scene captioning. Click left side to select image from photo gallery, click right side to take photo with camera.');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageCaptioningPage(),
                    ),
                  );
                },
                child: const Text(
                  "Tap to Caption Scene",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            )
          ]),
        ],
      ),
    );
  }
}
