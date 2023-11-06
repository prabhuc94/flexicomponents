import 'dart:math';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/helper/app_helper_date_formats.dart';
import 'package:flexicomponents/helper/app_helper_date_masker.dart';
import 'package:flexicomponents/helper/app_utils_dialog_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDatePickerDialog {
  CustomDatePickerDialog._();

  static void show(BuildContext context,
      {required DateTime initialDate,
      required DateTime firstDate,
      required DateTime lastDate,
      Function(DateTime?)? onChanged}) {
    DialogManager()
      ..context = context
      ..child = _CustomDatePicker(
          initialDate: initialDate, firstDate: firstDate, lastDate: lastDate, onChanged: onChanged,)
      ..barrierDismissible = true
      ..showClose = true
      ..show();
  }
}

const Size _calendarLandscapeDialogSize = Size(496.0, 346.0);
const Size _inputLandscapeDialogSize = Size(496, 160.0);
const Duration _dialogSizeAnimationDuration = Duration(milliseconds: 200);

class _CustomDatePicker extends StatelessWidget {
  final DateTime initialDate, firstDate, lastDate;
  final Function(DateTime?)? onChanged;
  final TextEditingController _dateInputController = TextEditingController();
  final ValueNotifier<DatePickerEntryMode> _onDatePickerModeChange = ValueNotifier(DatePickerEntryMode.calendar);

  _CustomDatePicker(
      {super.key,
      required this.initialDate,
      required this.firstDate,
      required this.lastDate,
      this.onChanged}) {
    _dateInputController.text = initialDate.toDate(dateFormat: DF.NORMAL_DATE);
  }

  Size _dialogSize(BuildContext context) {
    switch (_onDatePickerModeChange.value) {
      case DatePickerEntryMode.calendar:
      case DatePickerEntryMode.calendarOnly:
        return _calendarLandscapeDialogSize;
      case DatePickerEntryMode.input:
      case DatePickerEntryMode.inputOnly:
      return _inputLandscapeDialogSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool useMaterial3 = theme.useMaterial3;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final Orientation orientation = MediaQuery.orientationOf(context);
    final DatePickerThemeData datePickerTheme = DatePickerTheme.of(context);
    final DatePickerThemeData defaults = DatePickerTheme.defaults(context);
    final TextTheme textTheme = theme.textTheme;
    final double textScaleFactor =
        min(MediaQuery.textScaleFactorOf(context), 1.3);
    final Size dialogSize = _dialogSize(context) * textScaleFactor;
    final DialogTheme dialogTheme = theme.dialogTheme;
    TextStyle? headlineStyle;
    if (useMaterial3) {
      headlineStyle =
          datePickerTheme.headerHeadlineStyle ?? defaults.headerHeadlineStyle;
    } else {
      headlineStyle = orientation == Orientation.landscape
          ? textTheme.headlineSmall
          : textTheme.headlineMedium;
    }
    final Color? headerForegroundColor =
        datePickerTheme.headerForegroundColor ?? defaults.headerForegroundColor;
    headlineStyle = headlineStyle?.copyWith(color: headerForegroundColor);
    return Flex(
      direction: Axis.vertical,
      mainAxisSize: MainAxisSize.min,
      children: [
        Dialog(
          insetAnimationCurve: Curves.bounceIn,
          backgroundColor:
          (datePickerTheme.backgroundColor ?? defaults.backgroundColor) != Colors.transparent ? datePickerTheme.backgroundColor ?? defaults.backgroundColor : Theme.of(context).cardColor,
          elevation: useMaterial3
              ? datePickerTheme.elevation ?? defaults.elevation!
              : datePickerTheme.elevation ?? dialogTheme.elevation ?? 24,
          shadowColor: datePickerTheme.shadowColor ?? defaults.shadowColor,
          surfaceTintColor:
              datePickerTheme.surfaceTintColor ?? defaults.surfaceTintColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.spMin)),
          insetPadding:
              EdgeInsets.symmetric(horizontal: 16.spMin, vertical: 20.spMin),
          clipBehavior: Clip.antiAlias,
          child: ValueListenableBuilder(valueListenable: _onDatePickerModeChange, builder: (context, value, child) => AnimatedContainer(
            width: (_dialogSize(context) * textScaleFactor).width,
            height: (_dialogSize(context) * textScaleFactor).height,
            duration: _dialogSizeAnimationDuration,
            curve: Curves.easeIn,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: textScaleFactor,
              ),
              child: Builder(
                  builder: (BuildContext context) => Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _DatePickerHeader(
                        helpText: "Today Date".toUpperCase(),
                        titleText:
                        localizations.formatMediumDate(DateTime.now()),
                        titleStyle: headlineStyle,
                        orientation: orientation,
                        isShort: orientation == Orientation.landscape,
                        entryModeButton: IconButton(onPressed: (){
                          _onDatePickerModeChange.value = (value == DatePickerEntryMode.calendar) ? DatePickerEntryMode.input : DatePickerEntryMode.calendar;
                        }, icon: Icon((value == DatePickerEntryMode.calendar) ?  (useMaterial3 ? Icons.edit_outlined : Icons.edit) : (useMaterial3 ? Icons.calendar_month_outlined : Icons.calendar_month)), color: headerForegroundColor),
                      ),
                      if (useMaterial3) const VerticalDivider(),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                                child: picker(context)),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          )),
        ),
      ],
    );
  }

  Widget picker(BuildContext context) {
    Widget mode = Container();
    switch (_onDatePickerModeChange.value) {
      case DatePickerEntryMode.calendar:
      case DatePickerEntryMode.calendarOnly:
        mode = _calendarMode(context);
        break;
      case DatePickerEntryMode.input:
      case DatePickerEntryMode.inputOnly:
      mode = _inputMode(context);
        break;
    }
    return mode;
  }

  Widget _calendarMode(BuildContext context) => CalendarDatePicker(
    firstDate: firstDate,
    lastDate: lastDate,
    onDateChanged: (value) {
      onChanged?.call(value);
      context.closeDialog;
    },
    initialDate: initialDate,
  );

  Widget _inputMode(BuildContext context) => Center(
    child: Padding(
      padding: 16.spMin.padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          inputDatePicker(),
          _actions(context)
        ],
      ),
    ),
  );

  String? get validation {
    if (_dateInputController.text.isNullOrEmpty) {
      return "Input value is missing!";
    } else if (DateTime.tryParse(_dateInputController.text.toNotNull) == null) {
      return "Input date is invalid";
    } else if (_dateInputController.text.isNotNullOrEmpty) {
      var date = DateTime.tryParse(_dateInputController.text.toNotNull);
      if (date?.isBefore(firstDate) ?? false) {
        return "Date can't before first date!";
      } else if (date?.isAfter(lastDate) ?? false) {
        return "Date can't after last date!";
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  String? validator(String? value) {
    if (value.isNullOrEmpty) {
      return "Input value is missing!";
    } else if (DateTime.tryParse(value.toNotNull) == null) {
      return "Input date is invalid";
    } else if (value.isNotNullOrEmpty) {
      var date = DateTime.tryParse(value.toNotNull);
      if (date?.isBefore(firstDate) ?? false) {
        return "Date can't before first date!";
      } else if (date?.isAfter(lastDate) ?? false) {
        return "Date can't after last date!";
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Widget inputDatePicker() {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _dateInputController,
          validator: validator,
          autovalidateMode: AutovalidateMode.always,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.datetime,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
            LengthLimitingTextInputFormatter(10),
            DateInputFormatter(),
          ],
          decoration: const InputDecoration(
            labelText: "Enter Date",
          ),
        ),
      ],
    );
  }

  Widget _actions(BuildContext context) => Container(
    alignment: AlignmentDirectional.centerEnd,
    constraints: const BoxConstraints(minHeight: 52.0),
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: OverflowBar(
      spacing: 8,
      children: <Widget>[
        TextButton(
          onPressed: () => context.closeDialog,
          child: Text("Cancel".toUpperCase()),
        ),
        TextButton(
          onPressed: (){
            if (validation.isNullOrEmpty) {
              onChanged?.call(DateTime.parse(_dateInputController.text.toNotNull));
              context.closeDialog;
            }
          },
          child: Text("OK".toUpperCase()),
        ),
      ],
    ),
  );
}

class _DatePickerHeader extends StatelessWidget {
  /// Creates a header for use in a date picker dialog.
  const _DatePickerHeader({
    required this.helpText,
    required this.titleText,
    this.titleSemanticsLabel,
    required this.titleStyle,
    required this.orientation,
    this.isShort = false,
    this.entryModeButton,
  });

  static const double _datePickerHeaderLandscapeWidth = 152.0;
  static const double _datePickerHeaderPortraitHeight = 120.0;
  static const double _headerPaddingLandscape = 16.0;

  /// The text that is displayed at the top of the header.
  ///
  /// This is used to indicate to the user what they are selecting a date for.
  final String helpText;

  /// The text that is displayed at the center of the header.
  final String titleText;

  /// The semantic label associated with the [titleText].
  final String? titleSemanticsLabel;

  /// The [TextStyle] that the title text is displayed with.
  final TextStyle? titleStyle;

  /// The orientation is used to decide how to layout its children.
  final Orientation orientation;

  /// Indicates the header is being displayed in a shorter/narrower context.
  ///
  /// This will be used to tighten up the space between the help text and date
  /// text if `true`. Additionally, it will use a smaller typography style if
  /// `true`.
  ///
  /// This is necessary for displaying the manual input mode in
  /// landscape orientation, in order to account for the keyboard height.
  final bool isShort;

  final Widget? entryModeButton;

  @override
  Widget build(BuildContext context) {
    final DatePickerThemeData themeData = DatePickerTheme.of(context);
    final DatePickerThemeData defaults = DatePickerTheme.defaults(context);
    final Color? backgroundColor =
        themeData.headerBackgroundColor ?? defaults.headerBackgroundColor;
    final Color? foregroundColor =
        themeData.headerForegroundColor ?? defaults.headerForegroundColor;
    final TextStyle? helpStyle =
        (themeData.headerHelpStyle ?? defaults.headerHelpStyle)?.copyWith(
      color: foregroundColor,
    );

    final Text help = Text(
      helpText,
      style: helpStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    final Text title = Text(
      titleText,
      semanticsLabel: titleSemanticsLabel ?? titleText,
      style: titleStyle,
      maxLines: orientation == Orientation.portrait ? 1 : 2,
      overflow: TextOverflow.ellipsis,
    );

    switch (orientation) {
      case Orientation.portrait:
        return SizedBox(
          height: _datePickerHeaderPortraitHeight,
          child: Material(
            color: backgroundColor,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 24,
                end: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16),
                  help,
                  const Flexible(child: SizedBox(height: 38)),
                  Row(
                    children: <Widget>[
                      Expanded(child: title),
                      if (entryModeButton != null) entryModeButton!,
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      case Orientation.landscape:
        return SizedBox(
          width: _datePickerHeaderLandscapeWidth,
          child: Material(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _headerPaddingLandscape,
                  ),
                  child: help,
                ),
                SizedBox(height: isShort ? 16 : 56),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: _headerPaddingLandscape,
                    ),
                    child: title,
                  ),
                ),
                if (entryModeButton != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: entryModeButton,
                  ),
              ],
            ),
          ),
        );
    }
  }
}
