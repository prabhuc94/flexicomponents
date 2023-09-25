import 'dart:async';
import 'dart:ui';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/helper/app_paths_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskExpansionTile extends StatelessWidget {
  bool isExpanded = false;
  String? taskName, taskHrs;
  Function()? onDelete;
  Widget? child;
  final StreamController<bool> _expansionController = StreamController.broadcast(sync: true);

  TaskExpansionTile({super.key, this.isExpanded = false, this.taskHrs, this.taskName, this.onDelete, this.child}) {
    _expansionController.add(isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _expansionController.stream,
        builder: (context, snapshot) {
          return ExpansionTile(
            title: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Flex(direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                children: [
                  Expanded(child: Flex(direction: Axis.horizontal, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Task Name", style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 12.spMin, color: FlexiColors.EXPAND_TITLE)),
                      10.spMin.width,
                      Flexible(child: TextField(
                        controller: TextEditingController(text: taskName.toNotNull),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(overflow: TextOverflow.ellipsis),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        maxLines: 1,
                        selectionHeightStyle: BoxHeightStyle.includeLineSpacingMiddle,
                        decoration: InputDecoration(
                            contentPadding: 10.spMin.padding,
                            constraints: BoxConstraints(minWidth: 250.spMin),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.spMin)),
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white
                        ),
                      )),
                      16.spMin.width,
                      Text("Time Spent", style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 12.spMin, color: FlexiColors.EXPAND_TITLE)),
                      10.spMin.width,
                      Flexible(child: TextField(
                        controller: TextEditingController(text: taskHrs.toNotNull),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(overflow: TextOverflow.ellipsis),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        maxLines: 1,
                        selectionHeightStyle: BoxHeightStyle.includeLineSpacingMiddle,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            contentPadding: 10.spMin.padding,
                            constraints: BoxConstraints(maxWidth: 100.spMin),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.spMin)),
                            hintText: "hh:mm",
                            alignLabelWithHint: true,
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white
                        ),
                      )),
                    ],)),
                ],),
              trailing: IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline_rounded), splashRadius: 1, padding: EdgeInsets.zero, visualDensity: VisualDensity.compact, alignment: Alignment.centerLeft, constraints: BoxConstraints.loose(Size.fromWidth(16.spMin)),),
            ),
            tilePadding: 10.spMin.leftRightInsets,
            childrenPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            collapsedBackgroundColor: FlexiColors.GREYLIGHT,
            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.spMin)),
            iconColor: FlexiColors.DATEGREY,
            initiallyExpanded: (snapshot.data ?? false) || isExpanded,
            onExpansionChanged: (val) => _expansionController.add(val),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.spMin), side: BorderSide(strokeAlign: 1.spMin, color: FlexiColors.DATEGREY)),
            backgroundColor: FlexiColors.GREYLIGHT,
            children: [
              Container(
                width: context.width,
                color: Colors.white,
                padding: 10.spMin.padding,
                child: child,
              )
            ],
          );
        }
    );
  }
}
