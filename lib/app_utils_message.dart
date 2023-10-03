
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:local_notifier/local_notifier.dart';

class Message {
  Message._();

  static void showSnackBar(
      {required BuildContext context,
      required dynamic content,
      int seconds = 5,
      Color? backgroundColor,
      double? borderRadius = 5,
      double? fontSize = 12,
      double? elevation = 5,
      double? allPadding = 10}) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
      content: Text("$content",
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
              fontSize: fontSize?.spMin)),
      behavior: SnackBarBehavior.floating,
      padding: fontSize?.spMin.padding,
      elevation: elevation?.spMin,
      key: UniqueKey(),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      duration: Duration(seconds: seconds),
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColorLight,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius?.spMin ?? 0)),
    ));
  }

  static LocalNotification showNotification({String? title, String? subTitle, String? body, List<LocalNotificationAction>? actions}) {
    var notificaion = LocalNotification(title: title.toNotNull, subtitle: subTitle.toNotNull, body: body.toNotNull, identifier: PageStorageKey(DateTime.now().microsecondsSinceEpoch).value.toString(), actions: actions, silent: false);
    notificaion.show();
    return notificaion;
  }

  static showToast({required BuildContext context, int? duration, int? position, required String? message}) {
    try {
      FlutterToastr.show(message.toNotNull, context, duration: (duration ?? FlutterToastr.lengthLong), position: (position ?? FlutterToastr.bottom), textStyle: context.textTheme.labelMedium?.copyWith(color: Colors.white), backgroundRadius: 15.spMin);
    } catch (e) {
      if (kDebugMode) {
        print("CATCH_TOAST:\t$e");
      }
    }
  }
}
