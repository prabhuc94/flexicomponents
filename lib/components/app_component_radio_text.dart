import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RadioText<T> extends StatelessWidget {
  final T? groupValue;
  final T? value;
  final Color? activeColor, activeFontColor;
  final Color? defaultColor, defaultFontColor;
  final EdgeInsets? padding;
  final Function(T?)? onChanged;
  final String? label;

  const RadioText({super.key,
    required this.groupValue,
    required this.value,
    this.defaultColor,
    this.activeColor,
    this.activeFontColor,
    this.defaultFontColor,
    this.padding,
    this.onChanged,
    required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged?.call(value),
      borderRadius: BorderRadius.circular(10.spMin),
      child: Container(
        padding: EdgeInsets.only(
            left: 15.spMin, right: 15.spMin, top: 7.spMin, bottom: 7.spMin),
        color: (value == groupValue) ? (activeColor ?? Theme.of(context).primaryColor) : (defaultColor ?? Theme.of(context).colorScheme.onSecondary),
        child: Text(
          label.toNotNull,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color:
              (value == groupValue) ? (activeFontColor ?? Theme.of(context).cardColor) : (defaultFontColor ?? Theme.of(context).primaryColor)),
        ),
      ),
    );
  }
}
