import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CaptionDisplay extends StatefulWidget {
  const CaptionDisplay({
    Key? key,
    required this.output,
    required this.image,
  }) : super(key: key);

  final List<dynamic>? output;
  final File? image;

  @override
  State<CaptionDisplay> createState() => _CaptionDisplayState();
}

class _CaptionDisplayState extends State<CaptionDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/images/logo.svg'),
        toolbarHeight: 100.0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 250,
              width: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.file(
                  widget.image!,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Output: ${widget.output}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
