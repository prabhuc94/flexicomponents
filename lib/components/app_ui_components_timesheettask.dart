import 'dart:async';
import 'dart:ui';
import 'package:date_time/date_time.dart';
import 'package:flexicomponents/app_utils_message.dart';
import 'package:flexicomponents/components/app_ui_search_down.dart';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/formatter/app_helper_time_formatter.dart';
import 'package:flexicomponents/formatter/app_helper_time_masker.dart';
import 'package:flexicomponents/helper/app_paths_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:window_manager/window_manager.dart';

class TimesheetTaskExpansionTile extends StatelessWidget {
  bool isExpanded = false;
  String? taskName, taskHrs;
  Function()? onDelete;
  Widget? child;
  int? isDelete;
  TextEditingController? taskNameController;
  TextEditingController? taskHrsController;
  final TextEditingController _searchTaskController = TextEditingController();
  final StreamController<bool> _expansionController =
      StreamController.broadcast(sync: true);
  final StreamController<bool> _showDeleteController =
      StreamController.broadcast(sync: true);
  bool showDeleteButton = true;
  Function()? onUnFocus;
  String? maxHours;
  Function(String)? onTaskNameChange, onTaskHoursChange;
  Function(bool)? onExpand;
  FocusNode focusNode = FocusNode();
  bool? isError = false;
  StreamController<bool> showErrorBorderNotifier = StreamController.broadcast(sync: true);
  int type = 0;
  TimesheetTaskExpansionTile(
      {super.key,
      this.isExpanded = false,
      this.taskHrs,
      this.taskName,
      this.onDelete,
      this.child,
      this.isDelete,
      this.taskHrsController,
      this.taskNameController,
      this.showDeleteButton = true,
      this.isError,
      this.onTaskNameChange,
      this.onTaskHoursChange,
      this.onExpand,
      this.onUnFocus,
      this.type = 0}) {
    taskHrs = taskHrsController?.text;
    taskNameController ??= TextEditingController(text: taskName);
    _expansionController.add(isExpanded);
    _showDeleteController.add(taskName.isNotNullOrEmpty);
    var time = taskHrsController?.text.toHourTime();
    isError = ((time?.inSeconds ?? 0) == (Time.fromMinutes(0).inSeconds));
    showErrorBorderNotifier.add(isError ?? false);
    taskHrsController?.addListener(() {
      var time = taskHrsController?.text.toHourTime();
      isError = ((time?.inSeconds ?? 0) == (Time.fromMinutes(0).inSeconds));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onShowHoverHighlight: (val) {
        if (val == false) {
          if (taskHrs.equals(taskHrsController?.text) == false) {
            onTaskHoursChange?.call(
                "${taskHrsController?.text}"
                    .toNotNull);
          }
        }
      },
      child: Container(
        key: PageStorageKey(
            "${DateTime.now().millisecondsSinceEpoch}"),
        margin: 10.spMin.bottomPadding,
        child: StreamBuilder<bool>(
            key: PageStorageKey(
                "${DateTime.now().millisecondsSinceEpoch}"),
            stream: _expansionController.stream,
            initialData: isExpanded,
            builder: (context, snapshot) {
              return ExpansionTile(
                key: PageStorageKey(
                    "${DateTime.now().millisecondsSinceEpoch}"),
                title: ListTile(
                  mouseCursor: SystemMouseCursors.click,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    children: [
                      Expanded(
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Task Name",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.spMin,
                                      color: FlexiColors.EXPAND_TITLE)),
                              10.spMin.width,
                              if (type == 0)
                              Flexible(
                                  child: DropSearch(
                                    controller: taskNameController,
                                    items: [],
                                    /*searchInputDecoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          color: Theme.of(context).hintColor,
                                          fontSize: 12.spMin,
                                          fontWeight: FontWeight.w500),
                                      // hintText: "Search Task Name",
                                      contentPadding: 10.spMin.leftRightInsets,
                                      constraints:
                                      BoxConstraints(maxHeight: 30.spMin),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16.spMin),
                                      ),
                                    ),
                                    searchStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 12.spMin,
                                        fontWeight: FontWeight.w500),
                                    suggestionStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 12.spMin,
                                        fontWeight: FontWeight.w500),
                                    onSuggestionTap: (val) => {
                                      _searchTaskController
                                        ..clear()
                                        ..clearComposing(),
                                      onSelectedTask?.call(val.item)
                                    },*/
                                  )),
                              if (type > 0)
                              Flexible(
                                  child: TextField(
                                    controller: taskNameController,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 12.spMin,
                                        color: Theme.of(context).hintColor),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    maxLines: 1,
                                    onChanged: (val) {
                                      onTaskNameChange?.call(
                                          "${taskNameController?.text}".toNotNull);
                                      _showDeleteController.add(val.isNotNullOrEmpty);
                                    },
                                    selectionHeightStyle:
                                    BoxHeightStyle.includeLineSpacingMiddle,
                                    decoration: InputDecoration(
                                        contentPadding: 10.spMin.padding,
                                        constraints:
                                        BoxConstraints(minWidth: 250.spMin),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(16.spMin)),
                                        isDense: true,
                                        filled: true,
                                        fillColor: Colors.white),
                                    onTapOutside: (event) => onTaskNameChange?.call(
                                        "${taskNameController?.text}".toNotNull),
                                    onSubmitted: onTaskNameChange,
                                    onEditingComplete: () => onTaskNameChange?.call(
                                        "${taskNameController?.text}".toNotNull),
                                  )),
                              16.spMin.width,
                              Text("Time Spent",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.spMin,
                                      color: FlexiColors.EXPAND_TITLE)),
                              10.spMin.width,
                              Flexible(child: TextField(
                                    focusNode: focusNode..canRequestFocus = true,
                                    controller: taskHrsController,
                                    textAlignVertical: TextAlignVertical.center,
                                    onChanged: (val) => onChangeHours(val, context),
                                    onTap: () {
                                      focusNode.canRequestFocus = true;
                                    },
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 12.spMin,
                                        color: Theme.of(context).hintColor),
                                    minLines: 1,
                                    maxLines: 1,
                                    inputFormatters: [
                                      TimeMaskFormatter(isWithSec: false),
                                      LengthLimitingTextInputFormatter(5),
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
                                      TimeInputFormatter(),
                                    ],
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        contentPadding:
                                        EdgeInsets.symmetric(vertical: 10.spMin),
                                        constraints:
                                        BoxConstraints(maxHeight: 30.spMin),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(16.spMin)),
                                        hintText: "hh:mm",
                                        alignLabelWithHint: true,
                                        isCollapsed: true,
                                        isDense: true,
                                        filled: true,
                                        prefixIcon: IconButton(
                                            onPressed: () => decreaseMinutes(context),
                                            icon: Icon(Icons.remove, size: 14.spMin),
                                            padding: EdgeInsets.zero),
                                        suffixIcon: IconButton(
                                            onPressed: () => increaseMinutes(context),
                                            icon: Icon(Icons.add, size: 14.spMin),
                                            padding: EdgeInsets.zero),
                                        fillColor: Colors.white),
                                  )),
                              if (type > 0)
                              FutureBuilder(builder: (context, snapshot) => (snapshot.data == true) ? const Spacer() : 16.spMin.width, future: windowManager.isMaximized()),
                              if (type > 0)
                              Flexible(
                                  child: Container()),
                            ],
                          )),
                    ],
                  ),
                  // trailing: (isDeleted.data ?? false) && (showDeleteButton)
                  trailing: (showDeleteButton)
                      ? IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline_rounded),
                    splashRadius: 1,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    alignment: Alignment.centerLeft,
                    constraints:
                    BoxConstraints.loose(Size.fromWidth(16.spMin)),
                  )
                      : null,
                ),
                tilePadding: 10.spMin.leftRightInsets,
                childrenPadding: EdgeInsets.zero,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                collapsedBackgroundColor: FlexiColors.GREYLIGHT,
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.spMin)),
                iconColor: FlexiColors.DATEGREY,
                initiallyExpanded: (snapshot.data ?? false),
                onExpansionChanged: (val) {
                  isExpanded = val;
                  _expansionController.add(isExpanded);
                  onExpand?.call(isExpanded);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.spMin),
                    side: (isError ?? false) ? BorderSide(
                        strokeAlign: 1.spMin, color: Colors.red, width: 2.spMin) : BorderSide(
                        strokeAlign: 1.spMin, color: FlexiColors.DATEGREY)),
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
            }),
      ),
    );
  }

  void onChangeHours(String val, BuildContext context) {
      if (maxHours.isNotNullOrEmpty) {
        if (val.length > 4) {
          var time = val.toHourTime();
          // var maxTime = timesheetProvider.findBalanceHours(projects: projects, except: currentTask);
          Time? maxTime = Time.now();
          if (maxTime == Time.fromSeconds(0)) {
            var actualTaskHrs =
            taskHrs.toNotNull.toHourTime();
            maxTime = actualTaskHrs;
          }
          if ((time?.inSeconds ?? 0) >
              (maxTime?.inSeconds ?? 0)) {
            Message.showToast(
                context: context,
                message:
                "Spent cannot be more than tracked hours",
                duration: 3);
            taskHrsController?.text =
                "$taskHrs".toHHMM().toNotNull;
          } else {
            if ((time?.inSeconds ?? 0) >=
                Time.fromMinutes(5).inSeconds) {
              taskHrsController?.text =
                  "${time?.duration.diff}"
                      .toHHMM()
                      .toNotNull;
            } else {
              taskHrsController?.text =
                  "$taskHrs".toHHMM().toNotNull;
              Message.showToast(
                  context: context,
                  message:
                  "Spent cannot be less than 5 minutes",
                  duration: 3);
            }
          }
        }
      }
      _showDeleteController.add(val.isNotNullOrEmpty);
  }

  void increaseMinutes(BuildContext context, {int min = 5}) {
    if (maxHours.isNotNullOrEmpty) {
      if ((taskHrsController?.text.length ?? 0) > 4) {
        var time = taskHrsController?.text
            .toHourTime()
            ?.addDuration(Duration(minutes: min));
        // var maxTime = timesheetProvider.findBalanceHours(projects: projects, except: currentTask);
        Time? maxTime = Time.now();
        if (kDebugMode) {
          print("MAX_ADD_TIME:\t$maxTime");
        }
        var actualTaskHrs = taskHrs.toNotNull.toHourTime();
        if (maxTime == Time.fromSeconds(0)) {
          maxTime = actualTaskHrs;
        }
        if ((time?.inSeconds ?? 0) > (maxTime?.inSeconds ?? 0)) {
          if (((time?.inSeconds ?? 0) > (actualTaskHrs?.inSeconds ?? 0)) || ((time?.inSeconds ?? 0) > (maxTime?.inSeconds ?? 0))) {
            taskHrsController?.text =
                "${maxTime?.duration.diff}".toHHMM().toNotNull;
            focusNode.unfocus();
          }
          Message.showToast(
              context: context,
              message: "Spent cannot be more than tracked hours",
              duration: 3);
        } else {
          taskHrsController?.text = "${time?.duration.diff}".toHHMM().toNotNull;
          focusNode.unfocus();
        }
      }
    }
  }

  void decreaseMinutes(BuildContext context, {int min = -5}) {
    if (maxHours.isNotNullOrEmpty) {
      if ((taskHrsController?.text.length ?? 0) > 4) {
        if (taskHrsController?.text
            .toHourTime()?.inSeconds == 0) {
          return;
        }
        var time = taskHrsController?.text
            .toHourTime()
            ?.addDuration(Duration(minutes: min));
        // var maxTime = Time.fromStr(maxHours.toNotNull);
        // var maxTime = timesheetProvider.findBalanceHours(projects: projects, except: currentTask);
        Time? maxTime = Time.now();
        if (kDebugMode) {
          print("MAX_MINUS_TIME:\t$maxTime");
        }
        if ((maxTime == Time.fromSeconds(0)) || ((maxTime?.inSeconds ?? 0) < (taskHrs.toNotNull.toHourTime()?.inSeconds ?? 0))) {
          var actualTaskHrs = taskHrs.toNotNull.toHourTime();
          maxTime = actualTaskHrs;
        }

        if ((time?.inSeconds ?? 0) > (maxTime?.inSeconds ?? 0)) {
          Message.showToast(
              context: context,
              message: "Spent cannot be more than tracked hours",
              duration: 3);
        } else {
          if ((time?.inSeconds ?? 0) >= Time.fromMinutes(5).inSeconds) {
            taskHrsController?.text =
                "${time?.duration.diff}".toHHMM().toNotNull;
            focusNode.unfocus();
          } else {
            Message.showToast(
                context: context,
                message: "Spent cannot be less than 5 minutes",
                duration: 3);
          }
        }
      }
    }
  }
}
