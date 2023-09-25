import 'package:dropdown_search/dropdown_search.dart';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/helper/app_paths_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef String ItemAsString<T>(T item);

class DropDownField<T> extends StatelessWidget {
  ItemAsString<T>? itemToString;

  bool enabled = true;

  bool showSearch = true;

  ///offline items list
  List<T>? items;

  ///selected item
  T? selectedItem;

  Color? borderColor;

  double? radius;

  Function(T?)? onChanged;

  String? hintText;

  TextStyle? inputStyle;

  Color? fontColor;

  double? fontSize;

  FontWeight? fontWeight;

  FontWeight? selectedFontWeight;

  BoxConstraints? constraints;

  EdgeInsets? contentPadding, popupPadding;

  String? selectedPrefix;

  bool? activeMenuProps, searchTextProps;

  double? borderWidth;

  DropDownField(
      {Key? key,
      this.itemToString,
      this.enabled = true,
      this.showSearch = true,
      this.activeMenuProps = false,
      this.searchTextProps = false,
      this.selectedPrefix,
      this.items,
      this.selectedItem,
      this.onChanged,
      this.hintText,
      this.inputStyle,
      this.fontColor,
      this.fontSize,
      this.fontWeight,
      this.constraints,
      this.contentPadding,
      this.popupPadding,
      this.radius,
      this.selectedFontWeight,
      this.borderWidth = 1.0,
      this.borderColor})
      : super(key: key);

  InputBorder get _outlineBorder => OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius ?? 16.spMin),
      borderSide: BorderSide(color: borderColor ?? FlexiColors.Gray, width: (borderWidth ?? 1.0)));

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      key: key,
      enabled: enabled,
      items: (items ?? []),
      itemAsString: itemToString,
      dropdownButtonProps: const DropdownButtonProps(padding: EdgeInsets.zero, onPressed: null, hoverColor: Colors.transparent, focusColor: Colors.transparent, highlightColor: Colors.transparent, splashColor: Colors.transparent),
      selectedItem: selectedItem,
      onChanged: onChanged,
      dropdownBuilder: (context, selectedItem) => Padding(
          padding: (popupPadding ?? 10.spMin.padding),
          child: selectedPrefix.isNullOrEmpty ? Text(
              ((selectedItem != null)
                      ? "${selectedPrefix.toNotNull}${_selectedItemAsString(selectedItem)}"
                      : hintText)
                  .toNotNull,
              style: (inputStyle ?? Theme.of(context).textTheme.labelMedium)
                  ?.copyWith(
                      fontWeight: fontWeight,
                      color: fontColor,
                      fontSize: fontSize,
                      overflow: TextOverflow.ellipsis))
              : Text.rich(TextSpan(text: selectedPrefix.toNotNull,
              children: [
                TextSpan(
                  text: _selectedItemAsString(selectedItem).toNotNull,
                  style: (inputStyle ?? Theme.of(context).textTheme.labelMedium)
                      ?.copyWith(
                      fontWeight: selectedFontWeight,)
                )
              ],
              style: (inputStyle ?? Theme.of(context).textTheme.labelMedium)
              ?.copyWith(
              color: fontColor,
              fontSize: fontSize,
              overflow: TextOverflow.ellipsis)))
      ),
      popupProps: PopupProps.menu(
        constraints: BoxConstraints(maxHeight: 250.spMin),
          menuProps: (activeMenuProps ?? false) ? MenuProps(
              borderRadius: BorderRadius.circular(16.spMin),
              elevation: 5.spMin,
              clipBehavior: Clip.antiAliasWithSaveLayer) : const MenuProps(),
          itemBuilder: (context, item, isSelected) => Padding(
              padding: popupPadding ?? 10.spMin.padding,
              child: Text(_selectedItemAsString(item).toNotNull,
                  style: (inputStyle ?? Theme.of(context).textTheme.labelMedium)
                      ?.copyWith(
                          fontWeight: fontWeight,
                          color: fontColor,
                          fontSize: fontSize))),
          fit: FlexFit.loose,
          showSearchBox: (showSearch),
          searchFieldProps: (searchTextProps ?? false) ? TextFieldProps(
              decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.spMin)),
            contentPadding: 10.spMin.padding,
            constraints: BoxConstraints(maxHeight: 30.spMin),
          )) : const TextFieldProps(),
          listViewProps: const ListViewProps(
              clipBehavior: Clip.antiAliasWithSaveLayer, shrinkWrap: true)),
      dropdownDecoratorProps: DropDownDecoratorProps(
          baseStyle: (inputStyle ?? Theme.of(context).textTheme.labelMedium),
          dropdownSearchDecoration: InputDecoration(
            hintStyle: (inputStyle ?? Theme.of(context).textTheme.labelMedium)
                ?.copyWith(
                    color: Theme.of(context).hintColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight),
            constraints: (constraints ??
                BoxConstraints(maxHeight: 30.spMin, minWidth: 350.spMin)),
            contentPadding: (contentPadding ??
                EdgeInsets.only(
                    left: 10.spMin,
                    top: 0.spMin,
                    bottom: 0.spMin,
                    right: 10.spMin)),
            border: _outlineBorder,
            enabledBorder: _outlineBorder,
            focusedErrorBorder: _outlineBorder,
            errorBorder: _outlineBorder,
            focusedBorder: _outlineBorder,
            disabledBorder: _outlineBorder,
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            isCollapsed: false,
            enabled: enabled,
            hintText: hintText,
            alignLabelWithHint: true,
          )),
    );
  }

  ///function that return the String value of an object
  String _selectedItemAsString(T? data) {
    if (data == null) {
      return "";
    } else if (itemToString != null) {
      return "${itemToString?.call(data)}".toNotNull;
    } else {
      return data.toString();
    }
  }
}
