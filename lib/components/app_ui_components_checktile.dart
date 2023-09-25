import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/helper/app_paths_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckBoxTile extends StatelessWidget {
  CheckBoxTile(
      {super.key,
      this.listTileControlAffinity = ListTileControlAffinity.trailing,
      this.title,
      this.subTitle,
      this.contentPadding,
      this.onChanged,
      this.toolTip,
      required this.value});
  String? toolTip;
  ListTileControlAffinity? listTileControlAffinity;
  Widget? title, subTitle;
  EdgeInsets? contentPadding;
  final bool value;
  Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onChanged?.call(!value),
        child: Container(
          padding: contentPadding ?? 5.spMin.topPadding,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (listTileControlAffinity == ListTileControlAffinity.leading)
                _buildCheckBox(context, isChecked: value),
              Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [title ?? Container(), subTitle ?? Container()],
              ),
              if (listTileControlAffinity == ListTileControlAffinity.trailing)
                _buildCheckBox(context, isChecked: value, toolTip: toolTip.toNotNull),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckBox(BuildContext context, {bool? isChecked = false, String toolTip = ""}) {
    return Tooltip(
      message: toolTip,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 2.spMin, color: FlexiColors.DATEGREY),
            borderRadius: BorderRadius.circular(5.spMin)),
        child: (isChecked ?? false)
            ? Icon(
                Icons.close,
                color: FlexiColors.DATEGREY,
                size: 16.spMin,
              )
            : Container(
                padding: 8.spMin.padding,
              ),
      ),
    );
  }
}
