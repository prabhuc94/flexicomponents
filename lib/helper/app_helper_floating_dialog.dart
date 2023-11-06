import 'package:floating_dialog/floating_dialog.dart';
import 'package:flutter/material.dart';

Future<T?> showFloatingDialog<T>(BuildContext context, {required Widget child, bool barrierDismissible = true, Color barrierColor = Colors.transparent, String? barrierLabel, bool useSafeArea = true, bool useRootNavigator = true, RouteSettings? routeSettings, Offset? anchorPoint, TraversalEdgeBehavior? traversalEdgeBehavior, bool enableDragAnimation = false, bool autoCenter = true, void Function()? onClose}) async {
  return await showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
      anchorPoint: anchorPoint,
      barrierLabel: barrierLabel,
      routeSettings: routeSettings,
      traversalEdgeBehavior: traversalEdgeBehavior,
      useRootNavigator: useRootNavigator,
      builder: (_) => FloatingDialog(
        autoCenter: autoCenter,
        enableDragAnimation: enableDragAnimation,
        onClose: onClose,
        child: child),
      );
}