import 'dart:math';

import 'package:flutter/widgets.dart';


/// Close
class CloseIcon extends StatelessWidget {
  final Color color;
  CloseIcon({Key? key, required this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topLeft,
    child: Stack(children: [
      // Use rotated containers instead of a painter because it renders slightly crisper than a painter for some reason.
      Transform.rotate(
          angle: pi * .25,
          child:
          Center(child: Container(width: 14, height: 1, color: color))),
      Transform.rotate(
          angle: pi * -.25,
          child:
          Center(child: Container(width: 14, height: 1, color: color))),
    ]),
  );
}

/// Maximize
class MaximizeIcon extends StatelessWidget {
  final Color color;
  MaximizeIcon({Key? key, required this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) => _AlignedPaint(_MaximizePainter(color));
}

class _MaximizePainter extends _IconPainter {
  _MaximizePainter(Color color) : super(color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint p = getPaint(color);
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width - 1, size.height - 1), p);
  }
}

/// Restore
class RestoreIcon extends StatelessWidget {
  final Color color;
  RestoreIcon({
    Key? key,
    required this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => _AlignedPaint(_RestorePainter(color));
}

class _RestorePainter extends _IconPainter {
  _RestorePainter(Color color) : super(color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint p = getPaint(color);
    canvas.drawRect(Rect.fromLTRB(0, 2, size.width - 2, size.height), p);
    canvas.drawLine(Offset(2, 2), Offset(2, 0), p);
    canvas.drawLine(Offset(2, 0), Offset(size.width, 0), p);
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width, size.height - 2), p);
    canvas.drawLine(Offset(size.width, size.height - 2),
        Offset(size.width - 2, size.height - 2), p);
  }
}

/// Minimize
class MinimizeIcon extends StatelessWidget {
  final Color color;
  MinimizeIcon({Key? key, required this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) => _AlignedPaint(_MinimizePainter(color));
}

class _MinimizePainter extends _IconPainter {
  _MinimizePainter(Color color) : super(color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint p = getPaint(color);
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), p);
  }
}

class UpArrowIcon extends StatelessWidget {
  final Color color;
  final double? radius;
  const UpArrowIcon({Key? key, required this.color, this.radius}) : super(key: key);
  @override
  Widget build(BuildContext context) => _AlignedPaint(_UpArrowPainter(color), radius: radius,);
}

class _UpArrowPainter extends _IconPainter {
  _UpArrowPainter(Color color) : super(color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint p = getPaint(color)..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 2, 0);
    path.close();
    canvas.drawPath(path, p);
  }
}

class DownArrowIcon extends StatelessWidget {
  final Color color;
  final double? radius;
  const DownArrowIcon({Key? key, required this.color, this.radius}) : super(key: key);
  @override
  Widget build(BuildContext context) => _AlignedPaint(_DownArrowPainter(color), radius: radius);
}

class _DownArrowPainter extends _IconPainter {
  _DownArrowPainter(Color color) : super(color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint p = getPaint(color)..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, p);
  }
}

/// Helpers
abstract class _IconPainter extends CustomPainter {
  _IconPainter(this.color);
  final Color color;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AlignedPaint extends StatelessWidget {
  const _AlignedPaint(this.painter, {Key? key, this.radius = 5}) : super(key: key);
  final CustomPainter painter;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        widthFactor: 1,
        child: CustomPaint(size: Size.fromRadius((radius ?? 5)), painter: painter));
  }
}

Paint getPaint(Color color, [bool isAntiAlias = false]) => Paint()
  ..color = color
  ..style = PaintingStyle.stroke
  ..isAntiAlias = isAntiAlias
  ..strokeWidth = 1;