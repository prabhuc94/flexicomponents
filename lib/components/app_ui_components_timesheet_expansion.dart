import 'dart:async';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/helper/app_paths_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class TimeSheetExpansionTile extends StatelessWidget {
  bool isExpanded = false;
  String? projectname, totalHours;
  Widget? child;
  bool? isPrivate, isVerified;
  bool? screenExist = true;
  String? screenVerifiedStatus;
  Function()? onVerify;
  Function()? addtask;
  Function()? onPrivate, onWork, onDelete;
  Function(bool)? onExpand;
  Function()? onUnFocus;
  final StreamController<bool> _expansionController =
      StreamController.broadcast(sync: true);

  TimeSheetExpansionTile({
    super.key,
    this.onVerify,
    this.isExpanded = false,
    this.projectname,
    this.child,
    this.addtask,
    this.totalHours,
    this.isPrivate = false,
    this.onPrivate,
    this.onWork,
    this.isVerified,
    this.onDelete,
    this.onExpand,
    this.onUnFocus,
    this.screenVerifiedStatus,
    this.screenExist = true
  }) {
    _expansionController.add(isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onShowHoverHighlight: (val) {
        if (val == false) {
          onUnFocus?.call();
        }
      },
      child: Container(
        margin: 10.spMin.bottomPadding,
        child: StreamBuilder<bool>(
          key: UniqueKey(),
            stream: _expansionController.stream,
            initialData: isExpanded,
            builder: (context, snapshot) {
              return ExpansionTile(
                key: PageStorageKey("${DateTime.now().millisecondsSinceEpoch}"),
                title: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  children: [
                    Text.rich(TextSpan(
                        text: projectname.toNotNull,
                        recognizer: TapGestureRecognizer()..onTap = () {
                          isExpanded = !isExpanded;
                          _expansionController.add(isExpanded);
                          onExpand?.call(isExpanded);
                        }
                    ),
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 12.spMin)),
                    16.spMin.width,
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Hours Utilized : ',
                              style: TextStyle(
                                  fontSize: 12.spMin,
                                  fontWeight: FontWeight.w500,
                                  color: FlexiColors.BLACK)),
                          TextSpan(
                              text: totalHours,
                              style: TextStyle(
                                  color: FlexiColors.FULLBLACK,
                                  fontSize: 12.spMin,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: FlexiColors.DATEGREY),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.spMin)),
                            padding: EdgeInsets.only(
                                top: 5.spMin,
                                bottom: 5.spMin,
                                left: 10.spMin,
                                right: 10.spMin)),
                        onPressed: addtask,
                        child: Text(
                          'Add Task',
                          style: TextStyle(
                              fontSize: 12.spMin,
                              fontWeight: FontWeight.w600,
                              color: FlexiColors.DATEGREY),
                        )),
                    Visibility(visible: false,child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: FlexiColors.PRIMARY),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.spMin)),
                            padding: EdgeInsets.only(
                                top: 5.spMin,
                                bottom: 5.spMin,
                                left: 10.spMin,
                                right: 10.spMin)),
                        onPressed: (isPrivate ?? false) ? onWork : onPrivate,
                        child: Text(
                          'Change to ${(isPrivate ?? false) ? "Work" : "Private"}',
                          style: TextStyle(
                            fontSize: 12.spMin,
                            fontWeight: FontWeight.w600,
                          ),
                        )),),
                      10.spMin.width,
                    if ((isVerified ?? false) || (screenExist ?? false))
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: (isVerified ?? false) ? FlexiColors.GREEN : FlexiColors.PRIMARY),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.spMin)),
                              padding: EdgeInsets.only(
                                  top: 5.spMin,
                                  bottom: 5.spMin,
                                  left: 10.spMin,
                                  right: 10.spMin)),
                          onPressed: onVerify,
                          child: Text(
                            (isVerified ?? false) ? "Screens Verified" : "Verify Screens",
                            style: TextStyle(
                                fontSize: 12.spMin,
                                fontWeight: FontWeight.w600,
                                color: (isVerified ?? false) ? FlexiColors.GREEN : FlexiColors.PRIMARY
                            ),
                          )),
                    if ((screenExist == false) && (isVerified == false))
                      Tooltip(message: screenVerifiedStatus.toNotNull, child: Icon(Icons.hide_image_outlined, color: Theme.of(context).primaryColor, size: 20.spMin), onTriggered: (){}),
                      5.spMin.width,
                    if(onDelete != null)
                      IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline_rounded))
                  ],
                ),
                childrenPadding: EdgeInsets.zero,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                controlAffinity: ListTileControlAffinity.platform,
                collapsedBackgroundColor: Colors.white,
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.spMin)),
                trailing: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      isExpanded = !isExpanded;
                      _expansionController.add(isExpanded);
                      onExpand?.call(isExpanded);
                    },
                    child: Icon((snapshot.data ?? false || (snapshot.data ?? false))
                        ? Icons.remove_circle_outline_rounded
                        : Icons.add_circle_outline_rounded),
                  ),
                ),
                iconColor: FlexiColors.DATEGREY,
                initiallyExpanded: (snapshot.data ?? false),
                onExpansionChanged: (val) {
                  isExpanded = isExpanded;
                  _expansionController.add(isExpanded);
                  onExpand?.call(isExpanded);
                },
                maintainState: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.spMin)),
                backgroundColor: FlexiColors.GREYLIGHT,
                children: [
                  Container(
                    width: context.width,
                    color: Colors.white,
                    padding: 16.spMin.padding,
                    child: child,
                  )
                ],
              );
            }),
      ),
    );
  }
}
