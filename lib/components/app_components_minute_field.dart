import 'package:flexicomponents/components/app_components_icons.dart';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/formatter/app_helper_minute_formatter.dart';
import 'package:flexicomponents/helper/app_helper_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MinuteDayField extends StatelessWidget {
  final String? hintText;
  final bool? enabled;
  int type = 0; // 0 : MINUTE 1 : DAY
  int input = 0;
  final Function(int)? onChanged;
  final TextEditingController controller =
      TextEditingController(text: "0 Minutes");

  MinuteDayField({super.key, required this.input, this.hintText, this.enabled = true, this.onChanged, this.type = 0}) {
    controller.text = "$input ${(type == 0) ? 'Minutes' : 'Days'}";
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (val) {
          if (val.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
            _increase();
          } else if (val.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
            _decrease();
          }
        },
        child: TextField(
          controller: controller,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: (enabled ?? false) ? Theme.of(context).colorScheme.onSurface : Theme.of(context).hintColor,
              fontWeight: FontWeight.w500,
              fontSize: 12.spMin
          ),
          onChanged: (val) => onChanged?.call(int.tryParse(val.replaceAll(RegExp("[a-zA-Z:\s]"), "")) ?? 0),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          key: key,
          textAlign: TextAlign.start,
          enabled: (enabled ?? true),
          maxLines: 1,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          inputFormatters: [
            MinuteFormatter(type: type, suffix: (type == 0) ? 'Minutes' : 'Days'),
          ],
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.spMin)),
            focusColor: Colors.transparent,
            hintText: hintText.toNotNull,
            contentPadding: 10.spMin.padding,
            constraints: BoxConstraints(maxHeight: 30.spMin),
            enabled: (enabled ?? true),
            fillColor: Theme.of(context).disabledColor,
            filled: !(enabled ?? false),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.spMin), borderSide: BorderSide(color: Theme.of(context).disabledColor)),
            suffixIcon: Padding(padding: 6.spMin.padding, child: Flex(
              direction: Axis.vertical,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              verticalDirection: VerticalDirection.down,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _increase,
                    child: UpArrowIcon(color: !(enabled ?? false) ? HexColor("#bfbdbb") : Theme.of(context).hintColor, radius: 4.spMin),
                  ),
                ),
                2.spMin.height,
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _decrease,
                    child: DownArrowIcon(color: !(enabled ?? false) ? HexColor("#bfbdbb") : Theme.of(context).hintColor, radius: 4.spMin),
                  ),
                ),
              ],
            ),),
          ),
        ));
  }

  void _increase() {
    var count = int.tryParse(controller.text.replaceAll(RegExp("[a-zA-Z:\s]"), "")) ?? 0;
    if (type == 0) {
      if (count < 59) {
        count++;
      }
    } else if (type == 1) {
      if (count < 31) {
        count++;
      }
    }
    controller.text = "$count ${(type == 0) ? 'Minutes' : 'Days'}";
    onChanged?.call(count);
  }

  void _decrease() {
    var count = int.tryParse(controller.text.replaceAll(RegExp("[a-zA-Z:\s]"), "")) ?? 0;
    if (count >= 1) {
      count--;
    }
    controller.text = "$count ${(type == 0) ? 'Minutes' : 'Days'}";
    onChanged?.call(count);
  }
}
