import 'package:flexicomponents/components/app_components_custom_search_field.dart';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/path/app_paths_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef String ItemAsString<T>(T item);

class DropSearch<T> extends StatelessWidget {
  final ItemAsString<T>? itemToString;

  ///offline items list
  final List<T>? items;

  final T? selectedItem;

  final String? hintText;

  TextEditingController _searchController = TextEditingController();

  final bool? immediateClear;

  final Function(T?)? onChanged;

  final Function()? onClear;

  final bool? showSuffixIcon;

  final ValueNotifier<bool> _showClearIcon = ValueNotifier(false);

  DropSearch(
      {super.key,
      this.itemToString,
      this.items,
      this.hintText,
      this.immediateClear = false,
      this.onChanged,
      this.selectedItem,
      this.onClear,
      TextEditingController? controller,
      this.showSuffixIcon = true}) {
    if (controller != null) {
      _searchController = controller;
    }
      _searchController.addListener(() {
      _showClearIcon.value = _searchController.isNotNullOrEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _showClearIcon,
        builder: (__, showClearIcon, _) => CustomSearchField<T>(
              suggestionAction: SuggestionAction.unfocus,
              controller: _searchController,
              initialValue: selectedItem == null
                  ? null
                  : SearchFieldListItem<T>(_selectedItemAsString(selectedItem),
                      item: selectedItem,
                      child: Padding(
                        padding: 5.spMin.padding,
                        child: Text(
                          _selectedItemAsString(selectedItem),
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 12.spMin,
                              fontWeight: FontWeight.w500),
                        ),
                      )),
              suggestions: items
                      ?.where((element) => _selectedItemAsString(element)
                          .contains(_searchController.text))
                      .map((e) =>
                          SearchFieldListItem<T>(_selectedItemAsString(e),
                              item: e,
                              child: Padding(
                                padding: 5.spMin.padding,
                                child: Text(
                                  _selectedItemAsString(e),
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 12.spMin,
                                      fontWeight: FontWeight.w500),
                                ),
                              )))
                      .toList() ??
                  [],
              onClear: () => onClear?.call(),
              searchInputDecoration: InputDecoration(
                hintStyle: TextStyle(
                    overflow: TextOverflow.visible,
                    color: Theme.of(context).hintColor,
                    fontSize: 12.spMin,
                    fontWeight: FontWeight.w500),
                hintText: hintText.toNotNull,
                contentPadding: 10.spMin.leftRightInsets,
                constraints: BoxConstraints(maxHeight: 30.spMin),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.orange.shade100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.orange.shade100),
                ),
                suffixIcon: (showSuffixIcon ?? false)
                    ? (showClearIcon)
                ? Padding(
                        padding: 9.spMin.padding,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              onChanged?.call(null);
                            },
                            child: Icon(Icons.clear, size: 12.spMin),
                          ),
                        ),
                      )
                : Padding(
                  padding: 9.spMin.padding,
                  child: SvgPicture.asset(Vector.SEARCH),
                )
                    : null,
              ),
              searchStyle: TextStyle(
                  overflow: TextOverflow.visible,
                  color: Theme.of(context).hintColor,
                  fontSize: 12.spMin,
                  fontWeight: FontWeight.w500),
              suggestionStyle: TextStyle(
                  overflow: TextOverflow.visible,
                  color: Theme.of(context).hintColor,
                  fontSize: 12.spMin,
                  fontWeight: FontWeight.w500),
              onSuggestionTap: (val) {
                if (val.item != null) {
                  if (immediateClear ?? false) {
                    _searchController
                      ..clear()
                      ..clearComposing();
                  }
                  onChanged?.call(val.item);
                }
              },
            ));
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
