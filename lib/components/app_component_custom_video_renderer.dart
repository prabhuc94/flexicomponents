import 'dart:math';

import 'package:flutter/material.dart';

import 'package:webrtc_interface/webrtc_interface.dart';

import 'package:flutter_webrtc/flutter_webrtc.dart';

class CustomRTCVideoView extends StatelessWidget {
  const CustomRTCVideoView(
      this._renderer, {
        Key? key,
        this.objectFit = RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
        this.mirror = false,
        this.filterQuality = FilterQuality.low,
        this.placeholderBuilder,
      }) : super(key: key);

  final RTCVideoRenderer _renderer;
  final RTCVideoViewObjectFit objectFit;
  final bool mirror;
  final FilterQuality filterQuality;
  final WidgetBuilder? placeholderBuilder;

  RTCVideoRenderer get videoRenderer => _renderer;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            _buildVideoView(context, constraints));
  }

  Widget _buildVideoView(BuildContext context, BoxConstraints constraints) {
    return IntrinsicHeight(
      child: Container(
        width: constraints.maxWidth,
        constraints: constraints,
        child: FittedBox(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          fit: objectFit == RTCVideoViewObjectFit.RTCVideoViewObjectFitContain
              ? BoxFit.contain
              : BoxFit.cover,
          child: ValueListenableBuilder<RTCVideoValue>(
            valueListenable: videoRenderer,
            builder:
                (BuildContext context, RTCVideoValue value, Widget? child) {
              return SizedBox.fromSize(
                size: Size(
                  constraints.maxHeight * value.aspectRatio,
                  constraints.maxHeight
                ),
                child: child,
              );
            },
            child: Transform(
              transform: Matrix4.identity()..rotateY(mirror ? -pi : 0.0),
              alignment: FractionalOffset.center,
              child: videoRenderer.renderVideo
                  ? IntrinsicHeight(
                child: Texture(
                  textureId: videoRenderer.textureId!,
                  filterQuality: filterQuality,
                ),
              )
                  : placeholderBuilder?.call(context) ?? Container(),
            ),
          ),
        ),
      ),
    );
  }
}
