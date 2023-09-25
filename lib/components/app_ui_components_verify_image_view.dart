import 'dart:async';
import 'package:flexicomponents/components/app_ui_components_checktile.dart';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/helper/app_utils_image_size_analyser.dart';
import 'package:flexicomponents/paths/app_paths_vectors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';

class VerifyImage extends StatelessWidget {
  final Uint8List? memoryImage;
  final DateTime? timeStamp;
  bool? value;
  final String? imageUrl;
  bool? showCheckBox;
  final Function()? onTap;
  final Function()? onExpand;
  final BoxConstraints? constraints;
  final StreamController<bool> _controller =
      StreamController.broadcast(sync: true);

  VerifyImage(
      {Key? key,
      this.onTap,
      this.value,
      this.imageUrl,
      this.memoryImage,
      this.timeStamp,
      this.onExpand,
      this.showCheckBox = true,
      this.constraints})
      : super(key: key) {
    _controller.add(value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 10.spMin.padding,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      constraints: constraints,
      decoration: const BoxDecoration(),
      child: Flex(
        direction: Axis.vertical,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if ((memoryImage.isNotNullOrEmpty) || (imageUrl.isNotNullOrEmpty))
            InkWell(
              onTap: onExpand,
              child: (imageUrl.isNotNullOrEmpty)
                  ? Container(
                      constraints: constraints?.copyWith(
                          maxHeight: (constraints?.maxHeight ?? 0) - 22),
                      child: FastCachedImage(url: imageUrl.toNotNull,
                      errorBuilder: (context, error, stackTrace) => Image.asset(Vector.LOADER),
                      alignment: AlignmentDirectional.center,
                        fit: BoxFit.cover,
                        loadingBuilder: (p0, p1) => Image.asset(Vector.LOADER),
                      ),
                    )
                  : (memoryImage.isNotNullOrEmpty)
                      ? Container(
                          constraints: constraints?.copyWith(
                              maxHeight: (constraints?.maxHeight ?? 0) - 22),
                          child: Image(
                              image: MemoryImage(memoryImage ?? Uint8List(0)),
                              fit: BoxFit.fitWidth),
                        )
                      : Container(),
            ),
          if (showCheckBox ?? false)
            2.spMin.height,
          (showCheckBox ?? false)
              ? Flexible(
                  child: Flex(direction: Axis.vertical, mainAxisSize: MainAxisSize.min,
                  children: [
                    StreamBuilder<bool>(
                        stream: _controller.stream,
                        initialData: value,
                        builder: (context, snapshot) {
                          return InkWell(
                            onTap: () => {
                              onTap?.call(),
                              value = !(value ?? false),
                              _controller.add(value ?? false)
                            },
                            child: CheckBoxTile(
                              value: (snapshot.data ?? false),
                              contentPadding: EdgeInsets.zero,
                              listTileControlAffinity:
                              ListTileControlAffinity.trailing,
                              onChanged: (val) => {
                                onTap?.call(),
                                value = val,
                                _controller.add(val)
                              },
                              title: Text(
                                "${timeStamp?.toLocal().toDate(dateFormat: "hh:mm a")}"
                                    .toNotNull,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.spMin,
                                    color: Theme.of(context).hintColor),
                              ),
                              subTitle: (kDebugMode) ? (memoryImage.isNotNullOrEmpty)
                                  ? Text(
                                SizeAnalyser.filesize(
                                    (memoryImage ?? Uint8List(0))
                                        .lengthInBytes),
                                style:
                                Theme.of(context).textTheme.labelSmall,
                              )
                                  : Container()
                                  : null,
                            ),
                          );
                        })
                  ],))
              : Flexible(
                  child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "${timeStamp?.toLocal().toDate(dateFormat: "hh:mm a")}"
                        .toNotNull,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.spMin,
                        color: Theme.of(context).hintColor),
                  ),
                )),
        ],
      ),
    );
  }

  /*FadeInImage.assetNetwork(
                        placeholder: Vector.LOADER,
                        image: imageUrl.toNotNull,
                        filterQuality: FilterQuality.low,
                        placeholderFit: BoxFit.contain,
                        placeholderFilterQuality: FilterQuality.high,
                      )*/
}
