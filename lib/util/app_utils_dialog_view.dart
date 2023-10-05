import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogView {
  Widget? child;

  BuildContext context;

  EdgeInsets? contentPadding;

  double? elevation;

  Color? backgroundColor;

  bool? barrierDismissible;

  bool? showClose = true;

  Function()? onClose;

  bool _isShowing = false;

  bool get isShowing => _isShowing;

  set isShowing(bool value) {
    _isShowing = value;
  }

  DialogView(
      {required this.context,
      required this.child,
      this.contentPadding = EdgeInsets.zero,
      this.elevation = 0,
      this.backgroundColor = Colors.transparent,
      this.barrierDismissible = false,
      this.showClose = true,
      this.onClose});

  void show() async {
    await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          key: UniqueKey(),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          contentPadding: contentPadding,
          titlePadding: EdgeInsets.zero,
          title: (showClose ?? false)
              ? Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    isShowing = false;
                    onClose?.call();
                    ctx.closeDialog;
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    color: Theme.of(context).cardColor,
                  ))
            ],
          )
              : null,
          elevation: elevation,
          backgroundColor: backgroundColor,
          content: RawKeyboardListener(
            focusNode: FocusNode(),
            autofocus: true,
            onKey: (val) {
              if (val.isKeyPressed(LogicalKeyboardKey.escape) && (showClose ?? false)) {
                context.closeDialog;
              }
            },
            child: child!,
          ),
        ),
        barrierDismissible: (barrierDismissible ?? false),
        useSafeArea: true);
  }
}
