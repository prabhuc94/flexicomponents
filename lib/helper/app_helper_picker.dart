import 'dart:math';
import 'package:flexicomponents/app_ui_dialog_date_custom_picker.dart';
import 'package:flutter/material.dart';

class Picker {

  Picker._();

  /// DatePicker Method
  /// [lastDate] if it's null it'll automatically generate from (DateTime.now()) to next 100 years
  /// [firstDate] if it's null it'll automatically generate from (DateTime.now()) to past 100 years
  /// [initialDate] if it's null it's (DateTime.now())
  static void DatePicker({required BuildContext context, DateTime? initialDate, DateTime? firstDate, DateTime? lastDate, required Function(DateTime?)? onChanged, Color bgColor = Colors.white}) async {
    var last = lastDate ?? DateTime.now().add(const Duration(days: 36500));
    var first = firstDate ?? DateTime.now().subtract(const Duration(days: 36500));
    var initial = initialDate ?? DateTime.now();

    CustomDatePickerDialog.show(context, initialDate: initial, firstDate: first, lastDate: last, onChanged: onChanged, bgColor: bgColor);
    // DateTime? pickedDate = await showDatePicker(
    //   helpText: "CURRENT DATE",
    //     initialEntryMode: DatePickerEntryMode.calendar,
    //     context: context,
    //     initialDate: initial,
    //     firstDate: first,
    //     lastDate: last);
    //
    // if (pickedDate != null) {
    //   onChanged?.call(pickedDate);
    // }
  }

  static int randomInt({int? max = 5}) {
    Random random = Random();
    var count = random.nextInt((max ?? 5)) + 1;
    return count;
  }
}