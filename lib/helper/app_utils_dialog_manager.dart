import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogManager {

  DialogManager() {
    enableKeyListener = true;
    _showClose = true;
  }

  Widget? _child;

  double? _elevation;

  Color? _backgroundColor;

  bool? _barrierDismissible;

  bool? _showClose;

  EdgeInsets? _padding;

  Function()? _onClose;

  Offset? _offset;

  Widget get child => _child ?? Container();

  BuildContext? _context;

  AlignmentGeometry? _alignment;

  BuildContext? _localContext;

  set child(Widget value) {
    _child = value;
  }

  double get elevation => _elevation ?? 0;

  set elevation(double value) {
    _elevation = value;
  }

  Function()? get onClose => _onClose;

  set onClose(Function()? value) {
    _onClose = value;
  }

  bool get showClose => _showClose ?? true;

  set showClose(bool value) {
    _showClose = value;
  }

  bool get barrierDismissible => _barrierDismissible ?? false;

  set barrierDismissible(bool value) {
    _barrierDismissible = value;
  }

  Color get backgroundColor => _backgroundColor ?? Colors.transparent;

  set backgroundColor(Color value) {
    _backgroundColor = value;
  }


  EdgeInsets get padding => _padding ?? EdgeInsets.zero;

  set padding(EdgeInsets value) {
    _padding = value;
  }


  Offset? get offset => _offset;

  set offset(Offset? value) {
    _offset = value;
  }

  BuildContext? get context => _context;

  set context(BuildContext? value) {
    _context = value;
  }


  AlignmentGeometry? get alignment => _alignment;

  set alignment(AlignmentGeometry? value) {
    _alignment = value;
  }

  bool? _enableKeyListener = false;


  bool get enableKeyListener => (_enableKeyListener ?? true);

  set enableKeyListener(bool value) {
    _enableKeyListener = value;
  }

  void show() async {
    assert(context != null, "Context must not be null");
    await showDialog(
    context: context!,
    anchorPoint: offset,
    builder: (ctx) {
      _localContext = ctx;
      return AlertDialog(
        alignment: alignment ?? Alignment.center,
        key: UniqueKey(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        contentPadding: padding,
        titlePadding: EdgeInsets.zero,
        title: (showClose)
            ? Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  onClose?.call();
                  ctx.closeDialog;
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: Theme.of(ctx).cardColor,
                ))
          ],
        )
            : null,
        elevation: elevation,
        backgroundColor: backgroundColor,
        content: (enableKeyListener) ? RawKeyboardListener(
          key: UniqueKey(),
          focusNode: FocusNode(),
          autofocus: true,
          onKey: (val) {
            if (val.isKeyPressed(LogicalKeyboardKey.escape)) {
              close();
            }
          },
          child: child,
        ) : child,
      );
    },
    barrierDismissible: (barrierDismissible),
    useSafeArea: true);
  }

  void close() {
    onClose?.call();
    Future.delayed(const Duration(seconds: 1), () {
      if (_localContext != null) {
        _localContext!.closeDialog;
        _localContext = null;
      }
    });
  }
}