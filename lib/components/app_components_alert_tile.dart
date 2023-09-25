
import 'package:flexicomponents/components/app_components_minute_field.dart';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/helper/app_paths_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertTile extends StatelessWidget {
  final bool? value;
  final int? intervalTime;
  final bool? enabled;
  final Function(bool?)? onCheck;
  final Function(int)? onChanged;
  final String? label;
  final String? toolTipMessage;
  const AlertTile({super.key, required this.value, this.onCheck, required this.intervalTime, this.onChanged, this.enabled, this.label, this.toolTipMessage});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
      const EdgeInsets.only(left: 5.0, right: 0.0),
      horizontalTitleGap: 10,
      leading: Checkbox(
        value: (value ?? false),
        checkColor: Theme.of(context).colorScheme.onSurface,
        onChanged: onCheck,
        side: BorderSide(
            color: Theme.of(context)
                .colorScheme
                .onSurface),
        visualDensity: VisualDensity.comfortable,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(5.spMin)),
      ),
      title: MinuteDayField(input: (intervalTime ?? 0), onChanged: onChanged, enabled: enabled),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.toNotNull,
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.spMin)),
          5.spMin.width,
          Tooltip(
            padding: 5.spMin.padding,
            decoration: BoxDecoration(
                color: FlexiColors.TOOLTIP_BG_COLOR,
                border: Border.all(color:FlexiColors.PRIMARY)),
            message: toolTipMessage,
            textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 9.spMin,fontWeight: FontWeight.w500,color: FlexiColors.PRIMARY),
            child: Icon(Icons.help_outline, size: 15.spMin, color: FlexiColors.PRIMARY),
          ),
        ],
      ),
    );
  }
}
