import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopupSubMenuItem<T> extends PopupMenuEntry<T> {
  const PopupSubMenuItem({
    super.key,
    this.title,
    this.items,
    this.selectedItems,
    this.style,
    this.onSelected,
    this.offset,
  });

  final String? title;
  final List<T>? items;
  final List<T>? selectedItems;
  final Function(T)? onSelected;
  final TextStyle? style;
  final Offset? offset;

  @override
  PopupSubMenuState<T, PopupSubMenuItem<T>> createState() =>
      PopupSubMenuState<T, PopupSubMenuItem<T>>();

  @override
  // TODO: implement height
  double get height => kMinInteractiveDimension;

  @override
  bool represents(T? value) => false;
}

/// The [State] for [PopupSubMenuItem] subclasses.
class PopupSubMenuState<T, W extends PopupSubMenuItem<T>> extends State<W> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      elevation: 5.spMin,
      tooltip: "",
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Theme.of(context).colorScheme.onSecondary,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.spMin)),
      position: PopupMenuPosition.under,
      onCanceled: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
      onSelected: (T value) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        widget.onSelected?.call(value);
      },
      offset: Offset(110.spMin + (widget.offset?.dx ?? 0), (widget.offset?.dy ?? 0) - 20.spMin),
      //TODO This is the most complex part - to calculate the correct position of the submenu being populated. For my purposes is does not matter where exactly to display it (Offset.zero will open submenu at the poistion where you tapped the item in the parent menu). Others might think of some value more appropriate to their needs.
      itemBuilder: (BuildContext context) {
        return widget.items
                ?.map(
                  (item) => PopupMenuItem<T>(
                    mouseCursor: SystemMouseCursors.click,
                    padding: 10.spMin.leftRightInsets,
                    height: 30.spMin,
                    value: item,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(padding: 10.spMin.rightPadding, child: Icon((widget.selectedItems?.contains(item) ?? false) ? Icons.check_circle_outline_rounded : Icons.circle_outlined, size: 14.spMin,)),
                        Text("$item", style: widget.style,)
                      ],
                    ), //MEthod toString() of class T should be overridden to repesent something meaningful
                  ),
                )
                .toList() ??
            [];
      },
      child: Padding(
        padding: 10.spMin.leftRightInsets.copyWith(top: 5.spMin, bottom: 5.spMin),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(widget.title.toNotNull, style: widget.style),
            ),
            Icon(
              Icons.arrow_right,
              size: 20.spMin,
              color: widget.style?.color,
            ),
          ],
        ),
      ),
    );
  }
}
