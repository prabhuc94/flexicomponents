import 'dart:async';
import 'dart:typed_data';
import 'package:flexicomponents/components/app_ui_components_checktile.dart';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class VerifyImageView extends StatelessWidget {
  Uint8List? memoryImage;
  DateTime? timeStamp;
  bool? value;
  String? imageUrl;
  Function()? onTap;
  final StreamController<bool> _controller = StreamController.broadcast(sync: true);

  VerifyImageView(
      {super.key,
      this.memoryImage,
      this.imageUrl,
      this.timeStamp,
      this.value,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap?.call();
        value = !(value ?? false);
        _controller.add(value!);
      },
      child: Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: 10.spMin.padding,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: const BoxDecoration(),
            child: Flex(
              direction: Axis.vertical,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (memoryImage.isNotNullOrEmpty)
                  Image(
                      image: MemoryImage(memoryImage ?? Uint8List(0)),
                      fit: BoxFit.fitWidth),
                if (imageUrl.isNotNullOrEmpty)
                  Image.network(
                    imageUrl.toNotNull,
                    filterQuality: FilterQuality.medium,
                    fit: BoxFit.fitWidth,
                    loadingBuilder: (context, child, progress) =>
                        (progress == null)
                            ? child
                            : Center(
                                child: CircularProgressIndicator(
                                  color: Colors.orangeAccent.shade100,
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          (progress.expectedTotalBytes ?? 0)
                                      : null,
                                ),
                              ),
                  ),
                Flexible(
                    child: StreamBuilder<bool>(
                      stream: _controller.stream,
                      initialData: value,
                      builder: (context, snapshot) {
                        return CheckBoxTile(
                  value: (snapshot.data ?? false),
                  contentPadding: EdgeInsets.zero,
                  listTileControlAffinity: ListTileControlAffinity.trailing,
                  title: Text(
                        "${timeStamp?.toLocal().toDate(dateFormat: "hh:mm:ss a")}"
                            .toNotNull,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.spMin,
                            color: Theme.of(context).hintColor),
                  ),
                );
                      }
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
