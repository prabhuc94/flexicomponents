import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  const AnimatedText({
    Key? key,
    this.doShowMe = false,
    this.textContent = '',
    this.style,
  }) : super(key: key);

  final bool doShowMe;
  final String textContent;
  final TextStyle? style;

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _appearanceController;
  late String displayText;
  late String previousText;

  @override
  void initState() {
    super.initState();
    displayText = '';
    previousText = widget.textContent;
    _appearanceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..addListener(
          () => updateText(),
    );
    if (widget.doShowMe) {
      _doShowMe();
    }
  }

  void updateText() {
    String payload = widget.textContent;
    int numCharsToShow =
    (_appearanceController.value * widget.textContent.length).ceil();
    if (widget.doShowMe) {
      // make it grow
      displayText = payload.substring(0, numCharsToShow);
    } else {
      // make it shrink
      displayText =
          payload.substring(payload.length - numCharsToShow, payload.length);
    }
  }

  @override
  void didUpdateWidget(AnimatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.doShowMe != oldWidget.doShowMe) ||
        (widget.textContent != oldWidget.textContent)) {
      if (widget.doShowMe) {
        _doShowMe();
      } else {
        _doHideMe();
      }
    }
    if (widget.doShowMe && widget.textContent != previousText) {
      previousText = widget.textContent;
      _appearanceController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _appearanceController.dispose();
    displayText = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _appearanceController,
        builder: (context, child) {
          return Text(displayText, style: widget.style,);
        });
  }

  void _doShowMe() {
    _appearanceController
      ..duration = const Duration(milliseconds: 1500)
      ..forward();
  }

  void _doHideMe() {
    _appearanceController
      ..duration = const Duration(milliseconds: 500)
      ..reverse();
  }
}
