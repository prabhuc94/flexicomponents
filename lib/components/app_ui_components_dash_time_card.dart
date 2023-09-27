import 'package:flexicomponents/components/app_ui_components_slider.dart';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/helper/app_paths_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimerCard extends StatelessWidget {
  String? label;

  String? time;

  String? svgAsset;

  String? imgAsset;

  Function()? onTap;
  Function(bool)? onChanged;
  Color? activeColor, disableColor;
  bool? status;
  Color? color;
  ValueNotifier<String?>? timer;
  String package = "flexicomponents";

  TimerCard(
      {super.key,
      required this.label,
      this.time,
      this.svgAsset,
      this.imgAsset,
      this.status,
      this.onChanged,
      this.activeColor,
      this.disableColor,
      this.timer,
      this.color,
      this.onTap,
      this.package = "flexicomponents"});

  @override
  Widget build(BuildContext context) {
    return Card(
      key: UniqueKey(),
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(15.spMin),
        bottomRight: Radius.circular(15.spMin),
      )),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 3.spMin,
      margin: EdgeInsets.zero,
      child: Container(
        padding: 10.spMin.padding,
        decoration: BoxDecoration(
          gradient: (status == false) ? LinearGradient(colors: [
            FlexiColors.LINEAR_START,
            FlexiColors.LINEAR_END,
          ], begin: Alignment.topCenter,
            end: Alignment.bottomCenter,) : null
        ),
        child: Flex(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (svgAsset.isNotNullOrEmpty)
                SvgPicture.asset(svgAsset.toNotNull,
                    color: (color ?? Theme.of(context).primaryColor), height: 37.spMin, package: package),
              if (imgAsset.isNotNullOrEmpty)
                Image.asset(imgAsset.toNotNull, height: 37.spMin, package: package),
              if (imgAsset.isNotNullOrEmpty || svgAsset.isNotNullOrEmpty)
                6.spMin.height,
              if (timer != null)
                ValueListenableBuilder(
                  key: PageStorageKey("${DateTime.now().millisecondsSinceEpoch}"),
                    valueListenable: timer!, builder: (context, value, child) => Text(value.toNotNull.isNullOrEmpty ? "00:00" : value.toHHMM().toNotNull,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 20.spMin,
                        color: (color ?? Colors.black),
                        fontWeight: FontWeight.w700))),
                if (timer == null)
                  Text(time.toNotNull.isNullOrEmpty ? "00:00" : time.toNotNull.toHHMM().toNotNull,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 20.spMin,
                          color: (color ?? Colors.black),
                          fontWeight: FontWeight.w700)),
              5.spMin.height,
              Text(
                label.toNotNull,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: (color ?? Theme.of(context).hintColor),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.spMin),
              ),
              if (onChanged != null) 6.spMin.height,
              if (onChanged != null)
                SliderView(
                  textOff: "On".toUpperCase(),
                  textOn: "Off".toUpperCase(),
                  value: status,
                  contentSize: 9.spMin,
                  onChanged: onChanged,
                  elevation: 5.spMin,
                  colorOn: activeColor ?? Colors.green,
                  colorOff: disableColor ?? Colors.red,
                ),
            ]),
      ),
    );
  }
}
