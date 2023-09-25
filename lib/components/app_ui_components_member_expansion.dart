import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/helper/app_paths_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemberExpansionTile extends StatelessWidget {
  bool isExpanded = false;
  String? memberName, breakHrs, activeHrs, reportStatus, evaluationHrs;
  Widget? child;
  bool? isChecked = false;
  Function(bool)? onExpand;
  Function(bool?)? onCheck;
  EdgeInsets? margin;
  final ValueNotifier<bool> _onCheckNotifier = ValueNotifier(false);

  MemberExpansionTile(
      {super.key,
      this.isExpanded = false,
      this.memberName,
      this.breakHrs,
      this.activeHrs,
      this.child,
      this.onExpand,
      this.onCheck,
      this.isChecked = false,
      this.reportStatus,
      this.margin,
      this.evaluationHrs}) {
    _onCheckNotifier.value = (isChecked ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ExpansionTile(
        key: PageStorageKey("${DateTime.now().millisecondsSinceEpoch}"),
        title: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          children: [
            const Spacer(),
            RichText(
                text: TextSpan(
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.spMin,
                        color: FlexiColors.BLACK),
                    text: "Active : ",
                    children: [
                  TextSpan(
                      text: activeHrs.toNotNull,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600, fontSize: 12.spMin))
                ])),
            16.spMin.width,
            RichText(
                text: TextSpan(
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.spMin,
                        color: FlexiColors.BLACK),
                    text: "Break : ",
                    children: [
                  TextSpan(
                      text: breakHrs.toNotNull,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600, fontSize: 12.spMin))
                ])),
            16.spMin.width,
            if ((evaluationHrs.toHourTime()?.inSeconds ?? 0) > 0)
              RichText(
                  text: TextSpan(
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.spMin,
                    color: Theme.of(context).errorColor),
                text: "On Evaluation :\t${evaluationHrs.toHHMM()}",
              )),
            const Spacer(),
            ValueListenableBuilder(
                valueListenable: _onCheckNotifier,
                builder: (context, value, child) => Checkbox(
                    value: value,
                    onChanged: (val) {
                      onCheck?.call(val);
                      _onCheckNotifier.value = (val ?? false);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.spMin)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: Theme.of(context).hintColor)),
            2.spMin.width,
            RichText(
                text: TextSpan(
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.spMin,
                        color: FlexiColors.BLACK),
                    text: "Report : ",
                    children: [
                  TextSpan(
                      text: reportStatus.toNotNull,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.spMin,
                          color: reportColor))
                ])),
          ],
        ),
        childrenPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        controlAffinity: ListTileControlAffinity.platform,
        leading: Text(memberName.toNotNull,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(fontWeight: FontWeight.w600, fontSize: 12.spMin)),
        collapsedBackgroundColor: Colors.white,
        collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.spMin)),
        trailing: Icon((isExpanded)
            ? Icons.remove_circle_outline_rounded
            : Icons.add_circle_outline_rounded),
        iconColor: FlexiColors.DATEGREY,
        initiallyExpanded: isExpanded,
        onExpansionChanged: (val) => {isExpanded = val, onExpand?.call(val)},
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.spMin)),
        backgroundColor: FlexiColors.GREYLIGHT,
        children: [
          Container(
            width: context.width,
            color: Colors.white,
            padding: 16.spMin.padding,
            child: child,
          )
        ],
      ),
    );
  }

  Color? get reportColor {
    if (reportStatus.equals("ready")) {
      return FlexiColors.READY;
    } else if (reportStatus.equals("not ready")) {
      return FlexiColors.NOTEREADY;
    } else if (reportStatus.equals("submitted")) {
      return FlexiColors.SUBMITTED;
    } else if (reportStatus.equals("sent")) {
      return FlexiColors.SENT;
    } else {
      return FlexiColors.BLACK;
    }
  }
}
