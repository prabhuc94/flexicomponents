import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInteractiveViewer extends StatelessWidget {
  final Widget child;
  Function()? onNext;
  Function()? onPrevious;

  CustomInteractiveViewer({super.key, required this.child, this.onNext, this.onPrevious});

  Matrix4 _matrix = Matrix4.identity();
  Offset _position = Offset.zero;
  Offset _startPosition = Offset.zero;
  double _scaleFactor = 1.0;
  final Set<LogicalKeyboardKey> _pressedKeys = {};
  final ValueNotifier<Matrix4> _matrixNotifier = ValueNotifier(Matrix4.identity());

  bool _isControllPressing = false;


  bool get isControllPressing => _isControllPressing;

  set isControllPressing(bool value) {
    _isControllPressing = value;
  }

  void updateScale(double scale) {
    _scaleFactor = scale;
    _matrix = Matrix4.identity()
      ..scale(scale)
      ..translate(_position.dx, _position.dy);
    _matrixNotifier.value = _matrix;
  }

  void resetScale() {
    _scaleFactor = 1.0;
    _matrix = Matrix4.identity();
    _position = Offset.zero;
    _startPosition = Offset.zero;
    _matrixNotifier.value = _matrix;
  }

  void _onPanStart(DragStartDetails details) {
    _startPosition = details.localPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _position = details.localPosition - _startPosition;
    _matrixNotifier.value = Matrix4.identity()
      ..scale(_scaleFactor)
      ..translate(_position.dx, _position.dy);
  }

  void _onPanEnd(DragEndDetails details) {
  }

  void _handleKeyPress(RawKeyEvent event) {
    if ((event.isControlPressed &&
        ((event.logicalKey == LogicalKeyboardKey.minus) ||
            (event.logicalKey == LogicalKeyboardKey.numpadSubtract))) || (event.logicalKey == LogicalKeyboardKey.numpadSubtract)) {
      updateScale(_scaleFactor - 0.1);
    } else if ((event.isControlPressed &&
        ((event.logicalKey == LogicalKeyboardKey.equal) ||
            (event.logicalKey == LogicalKeyboardKey.numpadAdd))) || (event.logicalKey == LogicalKeyboardKey.numpadAdd)) {
      updateScale(_scaleFactor + 0.1);
    } else if ((event.isControlPressed &&
        ((event.logicalKey == LogicalKeyboardKey.digit0) ||
            (event.logicalKey == LogicalKeyboardKey.numpad0))) || (event.logicalKey == LogicalKeyboardKey.numpad0)) {
      resetScale();
    } else if ((event.isControlPressed && (event.logicalKey == LogicalKeyboardKey.arrowRight)) || (event.logicalKey == LogicalKeyboardKey.arrowRight)) {
      onNext?.call();
    } else if ((event.isControlPressed && (event.logicalKey == LogicalKeyboardKey.arrowLeft)) || (event.logicalKey == LogicalKeyboardKey.arrowLeft)) {
      onPrevious?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        key: key,
        autofocus: true,
        onKey: (event) {
          if (event is RawKeyUpEvent) {
            _pressedKeys.remove(event.logicalKey);
          } else if (event is RawKeyDownEvent) {
            _pressedKeys.add(event.logicalKey);
          }
          isControllPressing = event.isControlPressed;
          if (_pressedKeys.contains(LogicalKeyboardKey.controlLeft) ||
              _pressedKeys.contains(LogicalKeyboardKey.controlRight) ||
              _pressedKeys.contains(LogicalKeyboardKey.arrowLeft) ||
              _pressedKeys.contains(LogicalKeyboardKey.arrowRight) ||
              _pressedKeys.contains(LogicalKeyboardKey.numpadAdd) ||
              _pressedKeys.contains(LogicalKeyboardKey.numpadSubtract) ||
              _pressedKeys.contains(LogicalKeyboardKey.numpad0)
          ) {
            _handleKeyPress(event);
          }
        },
        focusNode: FocusNode(),
        child: Listener(
          onPointerSignal: (val) {
            if (val is PointerScrollEvent) {
              var dy = val.scrollDelta.dy;
              if (dy > 0) {
                // DOWN
                if (isControllPressing) {
                  // ZOOM-OUT
                  updateScale(_scaleFactor - 0.1);
                }
              } else if (dy < 0) {
                // UP
                if (isControllPressing) {
                  // ZOOM-IN
                  updateScale(_scaleFactor + 0.1);
                }
              }
            }
          },
          child: MouseRegion(
            key: PageStorageKey(DateTime.now().millisecondsSinceEpoch),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              key: PageStorageKey(DateTime.now().millisecondsSinceEpoch),
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: ValueListenableBuilder(
                key: PageStorageKey(DateTime.now().millisecondsSinceEpoch),
                valueListenable: _matrixNotifier,
                builder: (_, value, __) => Transform(
                  key: PageStorageKey(DateTime.now().millisecondsSinceEpoch),
                  transform: value,
                  alignment: FractionalOffset.center,
                  child: child,
                ),
              ),
            ),
          ),
        ));
  }
}
