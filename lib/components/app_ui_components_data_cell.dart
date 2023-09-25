import 'package:flutter/material.dart';

class RightClickDetector extends StatelessWidget {
  final Widget child;
  final Function(TapDownDetails details)? onRightClick;
  const RightClickDetector({super.key, required this.child, this.onRightClick});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onSecondaryTapDown: onRightClick,
        child: child,
      ),
    );
  }
}
