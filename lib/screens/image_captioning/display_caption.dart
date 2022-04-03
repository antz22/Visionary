import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:http/http.dart' as http;
import 'package:visionary/services/text_to_speech.dart';

class DisplayCaptionPage extends StatefulWidget {
  const DisplayCaptionPage({
    Key? key,
    required this.output,
    required this.image,
  }) : super(key: key);

  final List<dynamic>? output;
  final File? image;

  @override
  State<DisplayCaptionPage> createState() => _DisplayCaptionPageState();
}

class _DisplayCaptionPageState extends State<DisplayCaptionPage> {
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
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.8,
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
                  widget.output![0],
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
