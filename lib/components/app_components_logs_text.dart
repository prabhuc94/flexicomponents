import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/helper/app_helper_date_formats.dart';
import 'package:flexicomponents/helper/app_paths_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogsTextView extends StatelessWidget {
  final String? activity, status, windowName, windowTitle;
  final DateTime? timestamp;
  const LogsTextView({super.key, required this.activity, required this.windowName, required this.windowTitle, required this.status, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Flex(direction: Axis.horizontal,
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Flexible(
          child: Padding(
              padding: EdgeInsets.only(
                  bottom: 10.spMin),
              child: Text(
                "${timestamp?.toLocal().toDate(dateFormat: DF.T12S_FORMAT)}",
                style: style(context),
              ))),
      5.spMin.width,
      Expanded(flex: context.width ~/ 210,child: Padding(
          padding: EdgeInsets.only(
              bottom: 10.spMin),
          child: RichText(
            text: TextSpan(
              text: activity.isNullOrEmpty
                  ? "${windowName.toNotNull}: ${windowTitle.toNotNull}".stripeNull
                  : activity.stripeNull.split("<b>")[0],
              children: status.equalsOr(["MESSAGE", "System"]) && activity.toNotNull.contains("<b>") ? [
                TextSpan(text: activity.stripeNull.split("<b>").lastOrNull?.replaceAll("<b>", "").replaceAll("</b>", ""), style: style(context)?.copyWith(fontWeight: FontWeight.w600, color: FlexiColors.BLUE))
              ] : [],
              style: style(context),
            ),
          )),)
    ],);
  }

  TextStyle? style(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium?.copyWith(
        fontSize: 12.spMin,
        fontWeight: FontWeight.w500,
        color: activity.equals("Turned off Private mode") ? FlexiColors.GREEN :statusColor(status: status)
    );
  }

  Color statusColor({String? status}) {
    if (status.equalsOr(["WORK", "ONLINE", "SUCCESS"])) {
      return FlexiColors.GREEN;
    } else if (status
        .equalsOr(["PRIVATE", "OFFLINE", "ERROR", "BREAK", "ACTIVITY-STATUS"])) {
      return FlexiColors.RED;
    } else if (status.equals("IDLE")) {
      return FlexiColors.PRIMARY;
    } else if (status.equals("System")) {
      return FlexiColors.READY;
    } else if (status.equalsOr(["INFO"])) {
      return FlexiColors.SUBMITTED.withOpacity(0.8);
    } else if (status.equals("LIFECYCLE")) {
      return FlexiColors.BLUE.withOpacity(0.8);
    }
    return FlexiColors.DATEGREY;
  }
}
