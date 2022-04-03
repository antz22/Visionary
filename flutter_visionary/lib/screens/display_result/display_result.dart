import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DisplayResultPage extends StatefulWidget {
  const DisplayResultPage({
    Key? key,
    required this.output,
    required this.image,
    required this.type,
  }) : super(key: key);

  final List<dynamic>? output;
  final File? image;
  final String type;

  @override
  State<DisplayResultPage> createState() => _DisplayResultPage();
}

class _DisplayResultPage extends State<DisplayResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/images/logo.svg'),
        toolbarHeight: 100.0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: widget.type == 'Object Detection'
                    ? MediaQuery.of(context).size.width * 0.7
                    : MediaQuery.of(context).size.height * 0.5,
                width: widget.type == 'Object Detection'
                    ? MediaQuery.of(context).size.width * 0.9
                    : MediaQuery.of(context).size.width * 0.8,
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
                child: _buildText(widget.type, widget.output),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text _buildText(String type, List<dynamic>? output) {
    if (type == 'Read') {
      return Text(
        widget.output![0],
        style: const TextStyle(
          fontSize: 18,
        ),
      );
    } else if (type == 'Object Detection') {
      String objects = widget.output!.join(', ');
      return Text(
        'Image contains ' + objects,
        style: const TextStyle(
          fontSize: 18,
        ),
      );
    } else if (type == 'Image Captioning') {
      return Text(
        widget.output![0],
        style: const TextStyle(
          fontSize: 18,
        ),
      );
    } else {
      return const Text('Error');
    }
  }
}
