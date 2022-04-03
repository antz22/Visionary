import "package:simple_ocr_plugin/simple_ocr_plugin.dart";
import 'dart:convert';

class TextOCR {
  static Future<dynamic> run(String? filepath) async {
    if (filepath == null) {
      return "No image found";
    }
    var result = await SimpleOcrPlugin.performOCR(filepath);
    return json.decode(result);
  }
}
