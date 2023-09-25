import 'dart:convert';
import 'package:flexicomponents/components/app_components_icons.dart';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StickyColumn {
  final Key? key;
  final String? label;
  final bool? showSorting;
  bool? sort;
  bool? enable;

  StickyColumn(
      {this.key,
      this.label,
      this.showSorting = true,
      this.sort,
      this.enable = true});
}

class StickyRows<T> {
  final Key? key;
  final List<StickyCells> cells;
  T? value;
  bool? isSelected;

  StickyRows(
      {this.key, required this.cells, this.value, this.isSelected = false});
}

class StickyCells {
  final Key? key;
  final String? label;
  TextStyle? style;
  bool? showCheckbox;
  Function()? onPressed;
  Widget? prefix;
  Widget? suffix;
  StickyCells({this.key, this.label, this.style, this.showCheckbox = false, this.onPressed, this.prefix, this.suffix});
}

class StickyTable<T> extends StatelessWidget {
  final TextStyle? columnStyle;
  final TextStyle? rowStyle;
  Function(String, bool)? onSort;
  List<StickyColumn>? columns;
  TableBorder? rowBorder;
  TableBorder? columnBorder;
  Color? columnRowColor;
  Color? rowColor;
  List<StickyRows>? rows;
  Function(T?)? onRowClick;
  Function(TapDownDetails, T?)? onRowRightClick;
  T? selected;
  Map<int, TableColumnWidth>? columnWidths;
  Widget? emptyRow;
  EdgeInsets? columnPadding;

  StickyTable(
      {super.key,
      this.columnStyle,
      this.rowStyle,
      this.onSort,
      this.columns,
      this.columnRowColor,
      this.rowBorder,
      this.columnBorder,
      this.onRowClick,
      this.onRowRightClick,
      this.rows,
      this.rowColor,
      this.selected,
      this.columnWidths,
      this.columnPadding,
      this.emptyRow});

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    return Flex(
      direction: Axis.vertical,
      mainAxisSize: MainAxisSize.min,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: [
        Table(
          key: UniqueKey(),
          columnWidths: columnWidths,
          border: columnBorder,
          children: [
            TableRow(
                key: PageStorageKey(DateTime.now().millisecondsSinceEpoch),
                decoration: BoxDecoration(color: columnRowColor),
                children: columns
                        ?.where((element) => element.enable == true)
                        .map((e) => TableRowInkWell(
                              key: e.key,
                              mouseCursor: SystemMouseCursors.click,
                              child: Padding(
                                  padding: columnPadding ?? 10.spMin.padding,
                                  child: (e.showSorting ?? false) ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${e.label}".toNotNull,
                                        style: columnStyle ??
                                            context.textTheme.labelMedium
                                                ?.copyWith(
                                                fontSize: 12.spMin,
                                                fontWeight:
                                                FontWeight.w600),
                                      ),
                                      if (e.showSorting ?? false)
                                        5.spMin.width,
                                      if (e.showSorting ?? false)
                                        Column(
                                          children: [
                                            if (e.sort == true)
                                              UpArrowIcon(
                                                  color:
                                                  context.theme.hintColor,
                                                  radius: 3.5),
                                            if (e.sort == false)
                                              DownArrowIcon(
                                                color: context.theme.hintColor,
                                                radius: 3.5,
                                              ),
                                          ],
                                        )
                                    ],
                                  ) : Text(
                                    "${e.label}".toNotNull,
                                    style: columnStyle ??
                                        context.textTheme.labelMedium
                                            ?.copyWith(
                                            fontSize: 12.spMin,
                                            fontWeight:
                                            FontWeight.w600),
                                  ),
                              ),
                              onTap: () {
                                e.sort =
                                    e.sort == null ? true : !(e.sort ?? false);
                                onSort?.call(
                                    "${e.label}".toNotNull, (e.sort ?? false));
                              },
                            ))
                        .toList() ??
                    []),
          ],
        ),
        if (rows.isNotNullOrEmpty)
          Expanded(
            child: ListView(
              shrinkWrap: true,
              controller: controller,
              scrollDirection: Axis.vertical,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              key: UniqueKey(),
              children: [
                Table(
                  key: UniqueKey(),
                  columnWidths: columnWidths,
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: rowBorder ??
                      TableBorder(
                          horizontalInside: BorderSide(width: 0.2.spMin)),
                  children: rows
                          ?.map((e) => TableRow(
                              decoration: BoxDecoration(
                                  color: jsonEncode(e.value) == jsonEncode(selected)
                                      ? rowColor ?? Theme.of(context).primaryColor.withOpacity(0.08)
                                      : null),
                              children: e.cells
                                  .map((c) => TableRowInkWell(
                                        mouseCursor: SystemMouseCursors.click,
                                        onTap: () => (c.onPressed != null) ? c.onPressed?.call() : onRowClick?.call(e.value),
                                        onSecondaryTapDown: (val) =>
                                            onRowRightClick?.call(val, e.value),
                                        overlayColor: MaterialStatePropertyAll(
                                            (rowColor ??
                                                    context.theme.colorScheme
                                                        .primary)
                                                .withOpacity(0.08)),
                                        child: FocusableActionDetector(
                                            mouseCursor:
                                                SystemMouseCursors.click,
                                            child: Padding(
                                                padding: 15.spMin.padding,
                                                child:
                                                ((c.showCheckbox ?? false) || (c.prefix != null) || (c.suffix != null))
                                                    ? Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  mainAxisSize:
                                                  MainAxisSize
                                                      .min,
                                                  children: [
                                                    if (c.prefix != null)
                                                      c.prefix ?? Container(),
                                                    if (c.showCheckbox ?? false)
                                                      Checkbox(
                                                        value: (e.isSelected ?? false),
                                                        onChanged: (val) => c.onPressed?.call(),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.spMin)),
                                                        materialTapTargetSize: MaterialTapTargetSize.padded,
                                                        mouseCursor: SystemMouseCursors.click,
                                                        checkColor: context.colorScheme.onSurface,
                                                      ),
                                                    5.spMin.width,
                                                    Text(
                                                        c.label
                                                            .toNotNull,
                                                        style: c.style ??
                                                            rowStyle,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis),
                                                    if (c.suffix != null)
                                                      3.spMin.width,
                                                    if (c.suffix != null)
                                                      c.suffix ?? Container(),
                                                  ],
                                                )
                                                    : Text(
                                                  c.label
                                                      .toNotNull,
                                                  style: c.style ??
                                                      rowStyle,
                                                  overflow:
                                                  TextOverflow
                                                      .ellipsis,
                                                ))),
                                      ))
                                  .toList()))
                          .toList() ??
                      [],
                )
              ],
            ),
          ),
        if (rows.isNullOrEmpty && emptyRow != null)
          Expanded(
            child: Center(
              child: emptyRow,
            ),
          )
      ],
    );
  }
}
