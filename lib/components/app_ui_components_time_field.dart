import 'dart:ui';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/formatter/app_helper_time_formatter.dart';
import 'package:flexicomponents/formatter/app_helper_time_masker.dart';
import 'package:flexicomponents/helper/app_paths_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TimeField extends StatelessWidget {
  TextEditingController? controller;
  double? fontSize;
  Color? fontColor;
  int? maxLength;
  String inputMask = "##:##:##";
  double? radius;
  Color? borderColor;
  String? hintText;
  bool? enabled;
  bool? showMeridian;
  Color? fillColor;
  TextStyle? inputStyle;
  final ValueNotifier<String> _meridianNotifier = ValueNotifier("");
  TimeField(
      {Key? key,
      this.controller,
      this.fontSize,
      this.fontColor,
      this.maxLength = 8,
      this.inputMask = "##:##:##",
      this.radius,
      this.borderColor,
      this.hintText = "HH:mm:ss",
      this.enabled = true,
      this.showMeridian = false,
      this.fillColor,
      this.inputStyle})
      : super(key: key) {
    if (showMeridian == true) {
      controller?.addListener(() {
        // FIND MERIDIAN
        var time = controller?.text.toHourTime();
        if (time != null) {
          var durationDate = time.convertToDate(date: DateTime.now());
          if (durationDate != null) {
            var formatted = DateFormat('a').format(durationDate);
            _meridianNotifier.value = formatted;
          }
        } else {
          _meridianNotifier.value = "";
        }
      });
    }
  }

  InputBorder get _outlineBorder => OutlineInputBorder(
      borderRadius: BorderRadius.circular((radius ?? 0).spMin),
      borderSide: BorderSide(color: (borderColor ?? FlexiColors.Gray)));

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _meridianNotifier,
      builder: (context, value, child) => TextField(
        key: key,
        controller: controller,
        style: (inputStyle ?? Theme.of(context).textTheme.labelLarge)?.copyWith(
            overflow: TextOverflow.ellipsis,
            fontSize: fontSize,
            color: fontColor),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        maxLines: 1,
        enabled: enabled,
        inputFormatters: [
          TimeMaskFormatter(isWithSec: true),
          LengthLimitingTextInputFormatter(maxLength),
          FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
          TimeInputFormatter(),
        ],
        selectionHeightStyle: BoxHeightStyle.includeLineSpacingMiddle,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            contentPadding: 10.spMin.padding,
            enabledBorder: _outlineBorder,
            enabled: (enabled ?? false),
            disabledBorder: _outlineBorder,
            focusedBorder: _outlineBorder,
            border: _outlineBorder,
            errorBorder: _outlineBorder,
            focusedErrorBorder: _outlineBorder,
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).hintColor, fontWeight: FontWeight.w500),
            suffixText: value,
            suffixStyle: Theme.of(context).textTheme.labelSmall?.copyWith(color: fontColor, fontWeight: FontWeight.w400),
            alignLabelWithHint: true,
            isDense: true,
            filled: fillColor != null,
            fillColor: fillColor),
      ),
    );
  }
}
