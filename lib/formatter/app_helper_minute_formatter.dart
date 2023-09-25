import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flutter/services.dart';

class MinuteFormatter extends TextInputFormatter {
  final String? suffix;
  int type = 0; // 0 : MINUTES , 1 : DAYS

  MinuteFormatter({this.suffix = "Minutes", this.type = 0});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String formattedText = newValue.text;
    int value = (formattedText.isNotNullOrEmpty) ? (int.tryParse(formattedText.replaceAll(RegExp("[a-zA-Z:\s]"), "")) ?? 0) : 0;
    if (type == 0) {
      if (value > 59) {
        value = 59;
      }
    } else if (type == 1) {
      if (value > 31) {
        value = 31;
      }
    }
    newValue = newValue.copyWith(text: "$value $suffix");
    return newValue;
  }

}