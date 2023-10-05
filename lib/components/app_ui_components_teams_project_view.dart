
import 'package:flexicomponents/components/app_ui_components_quill_timesheet.dart';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/helper/app_paths_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeamsProjectView extends StatelessWidget {
  final String? projectName, hourSpend, taskName, taskReport;
  final Function()? onEdit;
  final bool? isScreenVerified;
  final EdgeInsets? margin;
  final Function()? onScreenVerify;
  final ValueNotifier<bool> onEditNotifier = ValueNotifier(false);
  bool? isEdit;
  final fq.QuillController? controller;
  int? viewType = 0; // 0 : PROJECT , 1 : TASK
  Widget? subChild;
  bool showEdit = true;

  TeamsProjectView({Key? key,
    this.projectName,
    this.hourSpend,
    this.onEdit,
    this.taskName,
    this.taskReport,
    this.isEdit = false,
    this.margin = EdgeInsets.zero,
    this.onScreenVerify,
    this.controller,
    this.viewType = 0,
    this.subChild,
    this.showEdit = false,
    this.isScreenVerified = false})
      : super(key: key) {
    // onEditNotifier.value = (isEdit ?? false) || (controller?.document.toPlainText().trim().toNotNull.isNotNullOrEmpty ?? false);
    onEditNotifier.value = (isEdit ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: margin,
      padding: margin,
      color: Colors.white,
      child: Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: context.colorScheme.onSecondary,
            padding: 7.spMin.topBottomInsets.copyWith(
              left: 7.spMin,
              right: 7.spMin
            ),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (viewType == 0)
                  Text(projectName.toNotNull,
                      style: Theme
                          .of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(
                          fontSize: 12.spMin,
                          color: FlexiColors.FULLBLACK,
                          fontWeight: FontWeight.w500)),
                if (viewType == 0)
                  25.spMin.width,
                if (viewType == 1)
                  RichText(
                      text: TextSpan(
                          style: Theme
                              .of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                              color: FlexiColors.EXPAND_TITLE,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.spMin),
                          text: "Task : ",
                          children: [
                            TextSpan(
                                text: taskName.toNotNull,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                    color: FlexiColors.FULLBLACK,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.spMin))
                          ])),
                if (viewType == 1)
                  const Spacer(),
                if (viewType == 1)
                  RichText(
                      text: TextSpan(
                          style: Theme
                              .of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                              color: FlexiColors.EXPAND_TITLE,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.spMin),
                          text: "Hours : ",
                          children: [
                            TextSpan(
                                text: hourSpend.toNotNull,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                    color: FlexiColors.FULLBLACK,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.spMin))
                          ])),
                if (viewType == 0)
                  const Spacer(),
                if (viewType == 0)
                  RichText(
                      text: TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = onScreenVerify,
                          style: Theme
                              .of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                              color: (isScreenVerified ?? false)
                                  ? FlexiColors.GREEN
                                  : FlexiColors.SUBMITTED,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.spMin),
                          text: (isScreenVerified ?? false)
                              ? "Screens Verified"
                              : "Screens yet to verify")),
                if (viewType == 1 && showEdit)
                  const Spacer(),
                if (viewType == 1 && showEdit)
                  InkWell(
                    onTap: () {
                      onEdit?.call();
                      onEditNotifier.value = (isEdit = !(isEdit ?? false));
                    },
                    child: Text("Edit >",
                        style: Theme
                            .of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
          ),
            0.5.spMin.height,
          const Divider(height: 0),
          0.5.spMin.height,
          if (viewType == 1)
            Container(
              padding: 7.spMin.topBottomInsets.copyWith(
                  left: 7.spMin,
                  right: 7.spMin
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                  color: context.theme.cardColor,
                  borderRadius: BorderRadius.circular(5.spMin)
              ),
              child: ValueListenableBuilder(
                  key: UniqueKey(),
                  valueListenable: onEditNotifier,
                  builder: (context, value, child) => (value) ? (controller != null) ? Container(
                    padding: 7.spMin.topBottomInsets.copyWith(
                        left: 7.spMin,
                        right: 7.spMin
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        color: context.theme.cardColor,
                        borderRadius: BorderRadius.circular(5.spMin)
                    ),
                    child: QuillEditorView(controller: controller!, content: taskReport.toNotNull),
                  ) : Container()
                      : Text(taskReport.toNotNull,
                      textAlign: TextAlign.start,
                      style: Theme
                          .of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(
                          color: FlexiColors.EXPAND_TITLE, fontSize: 12.spMin))),
            ),
          if (viewType == 0)
            subChild ?? Container(),
        ],
      ),
    );
  }
}
