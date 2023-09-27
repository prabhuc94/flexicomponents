import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/helper/app_paths_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SliderView extends StatelessWidget {
  final Function(bool)? onChanged;
  final bool? value;
  final String textOff;
  final String textOn;
  final double contentSize;
  final Color colorOn;
  final Color colorOff;
  final Color inactiveColor;
  final Color? borderColor;
  final double? elevation;
  TextStyle? labelStyle;
  final ValueNotifier<bool> _valueNotifier = ValueNotifier(false);

  SliderView({super.key,
    this.onChanged,
    this.textOff = "Private",
    this.textOn = "Work",
    this.contentSize = 9,
    this.value,
    this.borderColor,
    this.elevation = 0,
    this.colorOn = Colors.green,
    this.colorOff = Colors.red,
    this.inactiveColor = Colors.grey,
    this.labelStyle
  }) {
    _valueNotifier.value = (value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.spMin)),
      color: borderColor ?? Theme.of(context).cardColor,
      elevation: elevation,
      child: Container(
        decoration: BoxDecoration(color: FlexiColors.LIGHTGREY, borderRadius: BorderRadius.circular(50.spMin)),
        margin: 2.spMin.padding,
        child: ValueListenableBuilder<bool>(
          valueListenable: _valueNotifier,
          builder: (_, value, __) => Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            children: [
              _buildTextCard(context, text: textOn, color: (value == true) ? colorOn : inactiveColor, showCard: (value == true), onPressed: () => _determine(changeState: true)),
              _buildTextCard(context,text: textOff, color: (value == false) ? colorOff : inactiveColor, showCard: (value == false), onPressed: () => _determine(changeState: false)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextCard(BuildContext context, {String? text, Color? color, bool? showCard, Function()? onPressed}) {
    var textView = Padding(
      padding: EdgeInsets.only(left: 15.spMin, right: 15.spMin, top: 7.spMin, bottom: 7.spMin),
      child: Center(
        child: Text(
          text.toNotNull,
          style: (labelStyle ?? const TextStyle()).copyWith(
              color: color,
              fontSize: contentSize,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        borderRadius: BorderRadius.circular(50.spMin),
        onTap: onPressed,
        child: (showCard ?? false) ? Card(
          elevation: 2.spMin,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.spMin)),
          margin: EdgeInsets.zero,
          color: Theme.of(context).cardColor,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderOnForeground: true,
          semanticContainer: true,
          shadowColor: Colors.black38,
          child: textView,
        ) : textView,
      ),
    );
  }

  void _determine({bool changeState = false}) {
    _valueNotifier.value = changeState;
    onChanged?.call(changeState);
  }
}