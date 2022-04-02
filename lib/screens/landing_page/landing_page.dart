import 'package:flutter/material.dart';
import 'package:visionary/constants/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:visionary/services/text_to_speech.dart';

import '../home/home_page.dart';

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
              vertical: 4 * kDefaultPadding,
            ),
            child: SvgPicture.asset('assets/images/logo.svg'),
          ),
          SizedBox(
            width: 0.85 * MediaQuery.of(context).size.width, // <-- Your width
            height: 0.6 * MediaQuery.of(context).size.height, // <-- Your height
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              onPressed: () {
                TTS.speak('Scanning');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              child: const Text(
                "Tap to Scan",
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
