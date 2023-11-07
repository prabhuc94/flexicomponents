import 'dart:io';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/helper/app_utils_dialog_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

class HotKeyDialog {
  HotKeyDialog._();

  static void show(BuildContext context, Function(HotKey?)? onChange) {
    DialogManager()
      ..context = context
      ..child = _HotKeyDialogView(provider: HotKeyProvider(), onChange: onChange,)
      ..show();
  }
}

class _HotKeyDialogView extends StatelessWidget {
  final HotKeyProvider provider;
  final Function(HotKey?)? onChange;

  const _HotKeyDialogView({super.key, required this.provider, this.onChange});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (val) =>
          FocusScope.of(context).requestFocus(provider.focusNode),
      onEnter: (val) =>
          FocusScope.of(context).requestFocus(provider.focusNode),
      child: RawKeyboardListener(
          focusNode: provider.focusNode,
          autofocus: true,
          onKey: (value) => provider.setKey(value),
          child: Card(
            elevation: 5.spMin,
            color: context.theme.cardColor,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.spMin)),
            child: Padding(
              padding: 10.spMin.padding,
              child: ValueListenableBuilder(valueListenable: provider.keyController, builder: (_, value, __) => Flex(direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (value.isNullOrEmpty)
                    Text('Click here & Press a key or key combination', style: context.textTheme.labelSmall?.copyWith(color: context.theme.hintColor)),
                  Text(value, style: context.textTheme.labelMedium),
                  10.spMin.width,
                  if (value.isNotNullOrEmpty)
                    IconButton(
                      onPressed: () => provider.clear(),
                      icon: Icon(Icons.clear, size: 14.spMin),
                      mouseCursor: SystemMouseCursors.click,
                    ),
                  if (value.isNotNullOrEmpty)
                    10.spMin.width,
                  if(value.isNotNullOrEmpty)
                    ElevatedButton(
                      onPressed: () {
                        onChange?.call(provider.hotKey);
                        context.closeDialog;
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              context.theme.colorScheme.onSecondaryContainer)),
                      child: Text("Done", style: context.textTheme.labelMedium),
                    )
                ],)),
            ),
          )),
    );
  }
}

class HotKeyProvider {
  final FocusNode focusNode = FocusNode();
  bool _isControlPressed = false;
  bool _isAltPressed = false;
  bool _isShiftPressed = false;
  LogicalKeyboardKey? _logicalKeyboardKey;
  TextEditingController _controller = TextEditingController();
  ValueNotifier<String> keyController = ValueNotifier("");

  bool get isControlPressed => _isControlPressed;

  bool get isAltPressed => _isAltPressed;

  bool get isShiftPressed => _isShiftPressed;

  LogicalKeyboardKey? get logicalKeyboardKey => _logicalKeyboardKey;

  set isControlPressed(bool value) => _isControlPressed = value;

  set isAltPressed(bool value) => _isAltPressed = value;

  set isShiftPressed(bool value) => _isShiftPressed = value;

  set logicalKeyboardKey(LogicalKeyboardKey? value) =>
      _logicalKeyboardKey = value;

  get controller {
    _updateController();
    return _controller;
  }

  void _updateController() {
    var ctrl = (isControlPressed)
        ? (_isMacOs)
        ? "Cmd"
        : "Ctrl"
        : "";
    var alt = (isAltPressed) ? "Alt" : "";
    var shift = (isShiftPressed) ? "Shift" : "";
    var keyLabel = logicalKeyboardKey?.keyLabel;
    var data = [ctrl, alt, shift, keyLabel];
    data.removeWhere((element) => element.isNullOrEmpty);
    _controller.text = data.join(" + ");
    keyController.value = _controller.text;
  }

  bool get _isMacOs => Platform.isMacOS;

  void setKey(RawKeyEvent event) {
    if (event.runtimeType == RawKeyUpEvent) {
      return;
    }
    if (event.isShiftPressed) {
      isShiftPressed = true;
    }

    if (event.isAltPressed) {
      isAltPressed = true;
    }

    if (event.isControlPressed || event.isMetaPressed) {
      isControlPressed = true;
    }

    if (event.isMetaPressed ||
        event.isControlPressed ||
        event.isAltPressed ||
        event.isShiftPressed) {
    } else {
      logicalKeyboardKey = event.logicalKey;
    }
    _updateController();
  }

  void clear() {
    isShiftPressed = false;
    isAltPressed = false;
    isControlPressed = false;
    logicalKeyboardKey = null;
    _updateController();
  }

  HotKey? get hotKey {
    if (logicalKeyboardKey == null) {
      return null;
    }
    var control = (isControlPressed)
        ? (_isMacOs)
        ? KeyModifier.meta
        : KeyModifier.control
        : null;
    var shift = (isShiftPressed) ? KeyModifier.shift : null;
    var alt = (isAltPressed) ? KeyModifier.alt : null;
    List<KeyModifier> modifier = [];
    if (control != null) {
      modifier.add(control);
    }
    if (shift != null) {
      modifier.add(shift);
    }
    if (alt != null) {
      modifier.add(alt);
    }
    var keyCode = KeyCodeParser.fromLogicalKey(logicalKeyboardKey!);
    if (keyCode != null) {
      return HotKey(keyCode, identifier: "private_mode", scope: HotKeyScope.system, modifiers: modifier);
    } else {
      return null;
    }
  }
}
