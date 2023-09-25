import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/helper/app_paths_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlexiRadio<T> extends StatelessWidget {
  T? groupValue;
  T? value;
  Function(T?)? onChanged;
  EdgeInsets? padding, margin;
  double? radius;
  Color? activeColor;
  String? label;
  double? fontSize;
  FontWeight? fontWeight;
  Color? fontColor;
  double? space;

  FlexiRadio({
    Key? key,
    required this.groupValue,
    this.onChanged,
    this.padding,
    required this.value,
    this.radius,
    this.label,
    this.activeColor,
    this.space,
    this.fontWeight,
    this.fontSize,
    this.fontColor,
    this.margin
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: InkWell(
        onTap: () => onChanged?.call(value),
        radius: 5.spMin,
        hoverColor: Colors.transparent,
        child: Flex(
          direction: Axis.horizontal,
          children: [
            SizedBox.fromSize(
              size: Size.fromRadius(radius ?? 6.spMin),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Theme.of(context).hintColor)),
                padding: padding ?? 2.spMin.padding,
                child: (groupValue == value)
                    ? CircleAvatar(
                    backgroundColor:
                    activeColor ?? Theme.of(context).primaryColor)
                    : Container(),
              ),
            ),
            if (label.isNotNullOrEmpty) (space ?? 2).spMin.width,
            if (label.isNotNullOrEmpty)
              Text(label.toNotNull,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: fontSize ?? 12.spMin,
                      fontWeight: fontWeight ?? FontWeight.w500,
                      color: fontColor ?? FlexiColors.LIGHT_GREY))
          ],
        ),
      ),
    );
  }
}
