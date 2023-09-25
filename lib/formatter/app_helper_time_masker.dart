import 'package:flutter/services.dart';

class TimeMaskFormatter extends TextInputFormatter {
  bool isWithSec = true;
  TimeMaskFormatter({this.isWithSec = true});
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    String oldText = oldValue.text;
    if (newText.length > oldText.length) {
      if (isWithSec == true) {
        if (newText.length == 2 || newText.length == 5) {
          final formattedValue = "$newText:";
          return newValue.copyWith(text: formattedValue,
              selection: TextSelection.collapsed(
                  offset: formattedValue.length));
        }
      } else {
        if (newText.length == 2 || newText.length == 6) {
          final formattedValue = "$newText:";
          return newValue.copyWith(text: formattedValue,
              selection: TextSelection.collapsed(
                  offset: formattedValue.length));
        }
      }
    }
    return newValue;
  }

}