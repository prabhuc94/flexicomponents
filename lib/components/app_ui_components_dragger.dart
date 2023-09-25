import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class DragView extends StatelessWidget {
  final Widget child;
  const DragView({Key? key, required this.child,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: (details) {
          windowManager.startDragging();
        },
        onDoubleTap: () async {
          var status = await windowManager.isMaximized();
          status ? windowManager.unmaximize() : windowManager.maximize();
        },
        child: child,
      ),
    );
  }
}
