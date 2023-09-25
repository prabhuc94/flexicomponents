import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/helper/app_paths_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IncreaserBox extends StatelessWidget {
  final String? input;

  final Function()? increase, decrease;

  const IncreaserBox(
      {super.key, required this.input, required this.increase, required this.decrease});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 30.spMin, minWidth: 80.spMin),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        border: Border.all(color: FlexiColors.Gray, width: 0.5.spMin),
        borderRadius: BorderRadius.circular(25.spMin),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.spMin),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(input.toNotNull,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.spMin))),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: GestureDetector(
                  key: UniqueKey(),
                  onTap: increase,
                  child: Transform.scale(
                    scale: 1,
                    child: Icon(Icons.arrow_drop_up_outlined,
                        color: FlexiColors.TIMERINCREASE),
                  ))),
              Flexible(child: GestureDetector(
                  key: UniqueKey(),
                  onTap: decrease,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Icon(Icons.arrow_drop_down_outlined,
                        color: FlexiColors.TIMERINCREASE, fill: 0.1),
                  ))),
              10.spMin.height,
            ],
          ),
        ],
      ),
    );
  }
}
