import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HighlightTextCard<T> extends StatelessWidget {
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Color? textColor;
  final String? label;
  final T? value;
  final T? groupValue;
  final Function(T?)? onChanged;

  const HighlightTextCard({super.key, this.value, this.groupValue, this.padding, this.margin, this.backgroundColor, this.textColor, this.label, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.spMin),
      onTap: () => onChanged?.call(value),
      child: Container(
        margin: margin,
        padding: padding ?? 10.spMin.padding,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.spMin),
          color: (value == groupValue) ? (backgroundColor ?? Theme.of(context).primaryColor).withOpacity(.22) : Colors.transparent,
        ),
        child: Text(
          label.toNotNull,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: textColor ?? Theme.of(context).primaryColor, fontWeight: (value == groupValue) ? FontWeight.w600 : FontWeight.w500),
        ),
      ),
    );
  }
}
