import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/helper/app_helper_date_formats.dart';
import 'package:flexicomponents/helper/app_helper_picker.dart';
import 'package:flexicomponents/helper/app_paths_color.dart';
import 'package:flexicomponents/path/app_paths_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DateField extends StatelessWidget {
  DateTime? inputDate;
  int durationDays = 7;
  bool enabled = true;
  DateTime? lastDate;
  String dateFormat = "dd/MM/yyyy";
  Function(DateTime)? onChanged;
  double? fontSize;
  Color? fontColor;
  FontWeight? fontWeight;
  double? radius;
  Color? borderColor;
  EdgeInsets? padding;
  String? calendarAsset;

  final ValueNotifier<bool> _disablePrevious = ValueNotifier(false);
  final ValueNotifier<bool> _disableNext = ValueNotifier(false);

  DateField(
      {Key? key,
      this.inputDate,
      this.durationDays = 7,
      this.enabled = true,
      this.lastDate,
      this.dateFormat = "dd/MM/yyyy",
      this.onChanged,
      this.fontSize,
      this.fontColor,
      this.fontWeight,
      this.radius,
      this.padding,
      this.calendarAsset = Vector.CALENDARLIGHT,
      this.borderColor})
      : super(key: key) {
    lastDate = lastDate.onlyDate(format: DF.DATE_FORMAT);
    inputDate = inputDate.onlyDate(format: DF.DATE_FORMAT);
    _checkNextDate();
    _checkPreviousDate();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.spMin),
      onTap: enabled
          ? () => Picker.DatePicker(
              context: context,
              lastDate: (lastDate ?? DateTime.now()),
              firstDate: (inputDate?.isBefore(DateTime.now().subtract(Duration(days: durationDays))) ?? false) ? inputDate : DateTime.now().subtract(Duration(days: durationDays)),
              initialDate: inputDate,
              onChanged: (val) => (val != null ? onChanged?.call(val) : null))
          : null,
      child: Card(
        elevation: 0,
        color: (enabled) ? Theme.of(context).cardColor : Theme.of(context).disabledColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((radius ?? 20.spMin)),
            side: BorderSide(color: enabled ? (borderColor ?? FlexiColors.Gray) : Theme.of(context).disabledColor, width: 1.0)),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            3.spMin.width,
            ValueListenableBuilder(valueListenable: _disablePrevious, builder: (_, value, __) => InkWell(
              borderRadius: BorderRadius.circular(5.spMin),
              onTap: ((!value) && (enabled)) ? () => dateDecrease(day: 1) : null,
              child: Icon(Icons.chevron_left, color: (value) ? context.theme.disabledColor : enabled ? Theme.of(context).iconTheme.color : Theme.of(context).disabledColor),
            )),
            Padding(
              padding: padding ?? 5.spMin.padding,
              child: Text.rich(TextSpan(
                children: [
                  WidgetSpan(child: Text(inputDate.toDate(dateFormat: dateFormat),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: fontSize,
                          color: fontColor ?? Theme.of(context).hintColor,
                          fontWeight: fontWeight))),
                  WidgetSpan(child: 10.spMin.width),
                  WidgetSpan(child: SvgPicture.asset(calendarAsset.toNotNull, color: enabled ? Theme.of(context).iconTheme.color : Theme.of(context).hintColor, package: "flexicomponents",)),
                ]
              )),
            ),
            ValueListenableBuilder(valueListenable: _disableNext, builder: (_, value, __) => InkWell(
              borderRadius: BorderRadius.circular(5.spMin),
              onTap: ((!value) && (enabled)) ? () => dateIncrease(day: 1) : null,
              child: Icon(Icons.chevron_right, color: (value) ? context.theme.disabledColor :  enabled ? Theme.of(context).iconTheme.color : Theme.of(context).disabledColor),
            ),),
            3.spMin.width,
          ],
        ),
      ),
    );
  }

  void dateDecrease({int day = 1}) {
    var firstDate = (DateTime.now().subtract(Duration(days: durationDays)));
    var decreased = (inputDate ?? DateTime.now()).subtract(Duration(days: day));
    if (decreased.isAfter(firstDate)) {
      _disablePrevious.value = false;
      onChanged?.call(decreased);
    } else {
      _disablePrevious.value = true;
      onChanged?.call(firstDate);
    }
  }

  void dateIncrease({int day = 1}) {
    var increased = (inputDate ?? DateTime.now()).add(Duration(days: day));
    if ((increased).isBefore(lastDate ?? DateTime.now())) {
      onChanged?.call(increased);
      _disableNext.value = false;
    } else {
      _disableNext.value = true;
      onChanged?.call((lastDate ?? DateTime.now()));
    }
  }

  void _checkNextDate() {
    var current = (inputDate ?? DateTime.now()).onlyDate(format: DF.DATE_FORMAT);
    if ((current).isBefore(lastDate ?? DateTime.now())) {
      _disableNext.value = false;
    } else {
      _disableNext.value = true;
    }
  }

  void _checkPreviousDate() {
    var firstDate = (DateTime.now().subtract(Duration(days: durationDays))).onlyDate(format: DF.DATE_FORMAT);
    var current = (inputDate ?? DateTime.now());
    if (current.isAfter(firstDate)) {
      _disablePrevious.value = false;
    } else {
      _disablePrevious.value = true;
    }
  }
}
