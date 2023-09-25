import 'package:flutter/services.dart';

/// WHILE USING THIS FORMATTER KINDLY ADD this line [FilteringTextInputFormatter.allow(RegExp(r'[0-9-]'))]
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    String oldText = oldValue.text;
    if (newText.length > oldText.length) {
      if (newText.length == 4 || newText.length == 7) {
        final formattedValue = "$newText-";
        return newValue.copyWith(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length)
        );
      }
    }
    return newValue;
  }

}