import 'dart:io';

import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
class Helper {

  static Future<bool> openURL({String? url = "https://google.com/"}) async {
    final uri = Uri.parse(url.toNotNull);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    } else {
      if (kDebugMode) {
        print("Could not launch $url");
      }
      return false;
    }
  }

  static Future<bool> openFile({required File file, String scheme = "file"}) async {
    final uri = Uri(path: file.path, scheme: scheme);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    } else {
      if (kDebugMode) {
        print("Could not open file ${file.path}");
      }
      return false;
    }
  }

  static Future<File> createLog(
      {required String? input, String folder = "log", String? fileName, String mainFolder = "FlexiComponents"}) async {
    final Directory directory = await getTemporaryDirectory();
    var dir = Directory("${directory.path}/$mainFolder/$folder");
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final File file = File(
        '${dir.path}/${fileName.toNotNull}${DateTime.now().toDate(dateFormat: "yyyyMMddHHmm-ss")}.txt');
    return await file.writeAsString(input.toNotNull);
  }

}