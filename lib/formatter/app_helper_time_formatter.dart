import 'package:flutter/services.dart';

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String formattedText = newValue.text;
    int maxLength = formattedText.contains(":") ? 8 : 5;
    if (formattedText.length > maxLength) {
      formattedText = formattedText.substring(0, maxLength);
    }
    if (formattedText.length == 5 || formattedText.length == 8) {
      String hourString = formattedText.substring(0, 2);
      String minuteString = formattedText.substring(3,5);
      String secondString = (formattedText.length == 8) ? formattedText.substring(6,8) : "";

      int hour = int.tryParse(hourString) ?? 0;
      int minute = int.tryParse(minuteString) ?? 0;
      int second = int.tryParse(secondString) ?? 0;

      if (hour > 23) {
        hour = 23;
      }
      if (minute > 59) {
        minute = 59;
      }
      if (second > 59) {
        second = 59;
      }

      formattedText = '${hour.toString().padLeft(2,'0')}:${minute.toString().padLeft(2, '0')}';

      if (newValue.text.length == 8) {
        formattedText += ":${second.toString().padLeft(2,'0')}";
      }

      newValue = newValue.copyWith(text: formattedText, selection: TextSelection.collapsed(offset: formattedText.length));
    }
    return newValue;
  }

  int findCount(String input, String pattern) {
    var splitted = input.split(pattern);
    return splitted.length - 1;
  }

}