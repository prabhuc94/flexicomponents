import 'dart:convert';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef String ListSearchToString<T>(T item);

enum Mode { MULTI, SINGLE, NORMAL }

class ListSearch<T> extends StatefulWidget {
  bool? showSearch;

  ListSearchToString<T>? itemAsString;

  Mode? mode;

  ///offline items list
  List<T>? items;

  ///selected item
  T? selectedItem;

  bool? showResultAlways;

  bool? showCardView;

  Function(T?)? onChanged;

  List<T>? _itemsDuplicate;

  List<T>? _selectedItems;

  EdgeInsets? padding, margin;

  int? showMaxResult;

  bool? overlay;

  TextStyle? inputStyle;

  InputDecoration? inputDecoration;

  ListSearch({super.key,
    this.items,
    this.itemAsString,
    this.mode = Mode.NORMAL,
    this.selectedItem,
    this.showSearch = true,
    this.showResultAlways = false,
    this.showCardView = false,
    this.overlay = true,
    this.showMaxResult,
    this.onChanged,
    this.padding,
    this.margin,
    this.inputStyle,
    this.inputDecoration}) {
    _itemsDuplicate = items;
  }

  @override
  _ListSearchState<T> createState() => _ListSearchState<T>();
}

class _ListSearchState<T> extends State<ListSearch<T>> {
  final TextEditingController _searchController = TextEditingController();
  String? searchText;

  final List<T>? _selectedDuplicateItems = [];

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  ThemeData? theme;

  @override
  void initState() {
    OverlayState? overlayState = Overlay.of(context);
    _selectedDuplicateItems?.addAll(widget._selectedItems ?? []);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.overlay ?? false) {
        _focusNode.addListener(() {
          if (_focusNode.hasFocus) {
            _overlayEntry = _createOverlayEntry();

            overlayState.insert(_overlayEntry!);
          } else {
            _overlayEntry?.remove();
          }
        });
      }
    });
    super.initState();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    Size? overlaySize = renderBox?.size;
    Size screenSize = MediaQuery
        .of(context)
        .size;
    double screenWidth = screenSize.width;
    return OverlayEntry(
        builder: (context) =>
            Positioned(
              width: overlaySize?.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, (overlaySize?.height ?? 0) + 5.0),
                child: Material(
                  elevation: 1.0,
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: screenWidth,
                        maxWidth: screenWidth,
                        minHeight: 0,
                      ),
                      child: (widget.showResultAlways ?? false)
                          ? _buildResultView
                          : searchText.isNotNullOrEmpty
                          ? _buildResultView
                          : null),
                ),
              ),
            ));
  }

  void doCheckSelection() {
    if (widget.overlay == true) {
      if (widget.selectedItem != null) {
        _searchController.text = _selectedItemAsString(widget.selectedItem);
      } else {
        _searchController.clear();
        _searchController.clearComposing();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    doOnchange(searchText);
    doCheckSelection();
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      child: _buildView,
    );
  }

  Widget get _buildView {
    return Container(
      decoration: const BoxDecoration(),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      constraints: (widget.items.isNullOrEmpty)
          ? const BoxConstraints()
          : BoxConstraints(maxHeight: 50.spMin),
      child: Padding(
        padding: 5.spMin.padding,
        child: Flex(
            mainAxisSize: MainAxisSize.min,
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.showSearch ?? false) _buildSerchBox,
              if (widget.showSearch ?? false) 5.spMin.height,
              _checkOverlay,
            ]),
      ),
    );
  }

  Widget get _checkOverlay {
    return (widget.overlay ?? false)
        ? Container()
        : (widget.showResultAlways ?? false)
        ? _buildResultView
        : searchText.isNotNullOrEmpty
        ? _buildResultView
        : Container();
  }

  Widget get _buildResultView {
    return widget._itemsDuplicate.isNotNullOrEmpty
        ? ListView.builder(
      itemBuilder: (_, position) => (widget.mode == Mode.NORMAL || widget.mode == Mode.SINGLE) ? _buildNormalView(widget._itemsDuplicate?[position]) : Container(),
      itemCount: widget._itemsDuplicate?.length,
      shrinkWrap: true,
    )
        : _buildNoRecordFound;
  }

  Widget _buildNormalView(T? item) {
    return ListTile(
      onTap: () {
        widget.onChanged?.call(item);
        if (widget.showResultAlways == false) {
          _searchController.text = _selectedItemAsString(item);
          _focusNode.unfocus();
          searchText = null;
        }
      },
      shape: const RoundedRectangleBorder(),
      selected: jsonEncode(item).equals(jsonEncode(widget.selectedItem)),
      dense: true,
      tileColor: theme?.listTileTheme.tileColor,
      selectedTileColor: theme?.hoverColor,
      title: Text(
        _selectedItemAsString(item),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  void get _setState {
    if (mounted) {
      setState(() {});
    }
  }

  void doOnchange(String? searchValue) {
    searchText = searchValue;
    widget._itemsDuplicate = widget.items
        ?.where((element) =>
    _selectedItemAsString(element)
        .toLowerCase()
        .contains(searchText.toNotNull.toLowerCase()))
        .toList();
    if (widget.showMaxResult != null) {
      widget._itemsDuplicate = widget._itemsDuplicate.isNotNullOrEmpty
          ? widget._itemsDuplicate?.take(widget.showMaxResult ?? 0).toList()
          : widget._itemsDuplicate;
    }
    if (widget.overlay ?? false) {
      if (searchText.isNotNullOrEmpty) {
        _overlayEntry?.markNeedsBuild();
      }
    } else {
      _setState;
    }
  }

  Widget get _buildSerchBox {
    return (widget.overlay ?? false)
        ? CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        focusNode: _focusNode,
        style: widget.inputStyle,
        controller:
        (_selectedItemAsString(widget.selectedItem).isNullOrEmpty)
            ? _searchController
            : null,
        onChanged: doOnchange,
        decoration: widget.inputDecoration,
      ),
    )
        : TextField(
      controller: _searchController,
      style: widget.inputStyle,
      onChanged: doOnchange,
      decoration: widget.inputDecoration,
    );
  }

  Widget get _buildNoRecordFound {
    return Container(
      padding: 10.spMin.padding,
      child: const Center(
        child: Text(
            "No record found",
            style: TextStyle(
                fontWeight: FontWeight.w500
            )),
      ),
    );
  }

  ///function that return the String value of an object
  String _selectedItemAsString(T? data) {
    if (data == null) {
      return "";
    } else if (widget.itemAsString != null) {
      return widget.itemAsString?.call(data) ?? "";
    } else {
      return data.toString();
    }
  }
}
