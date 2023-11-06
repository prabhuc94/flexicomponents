import 'dart:developer';
import 'dart:io';
import 'package:date_time/date_time.dart';
import 'package:flexicomponents/helper/app_helper_date_formats.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringManipulation on String? {
  bool get isNullOrEmpty => (this == null || this?.isEmpty == true);

  bool get isNotNullOrEmpty =>
      (this != null && this?.trim().isNotEmpty == true);

  String get firstLetter =>
      isNotNullOrEmpty ? this?.substring(0, 1) ?? "E" : "E";

  String toCapitalized() => isNotNullOrEmpty
      ? '${this?[0].toUpperCase()}${this?.substring(1).toLowerCase()}'
      : ''; // 'hello world' => 'Hello world'
  String toTitleCase() => isNotNullOrEmpty
      ? "${this?.replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ')}"
      : ""; // 'hello world' => 'Hello World'
  String get timestampToDate {
    if (isNotNullOrEmpty) {
      var date = DateFormat("yyyy-MM-dd HH:mm:ss").parse(this ?? "");
      return DateFormat("dd-MMM-yyyy hh:mm a").format(date);
    } else {
      return this ?? "";
    }
  }

  bool equals(String? input, {bool ignoreCase = true}) {
    return isNotNullOrEmpty
        ? !ignoreCase
            ? this == input
            : this?.toLowerCase() == "$input".toLowerCase()
        : false;
  }

  bool equalsOr(List<String> input, {bool ignoreCase = true}) {
    return isNotNullOrEmpty
        ? ignoreCase
            ? input
                .where((element) =>
                    element.toLowerCase().equals(toNotNull.toLowerCase()))
                .toList()
                .isNotNullOrEmpty
            : input
                .where((element) => element.equals(toNotNull))
                .toList()
                .isNotNullOrEmpty
        : false;
  }

  bool containsOr(List<String> input, {bool ignoreCase = true}) {
    return isNotNullOrEmpty
        ? ignoreCase
        ? input
        .where((element) => toNotNull.toLowerCase().contains(element.toNotNull.toLowerCase()))
        .toList()
        .isNotNullOrEmpty
        : input
        .where((element) => toNotNull.contains(element))
        .toList()
        .isNotNullOrEmpty
        : false;
  }

  String get toNotNull =>
      ((isNullOrEmpty == true) || this == "null") ? "" : "$this";

  int get toZero => ((isNullOrEmpty == true) || this == "null")
      ? 0
      : (int.tryParse("$this") ?? 0);

  double get toDouble => ((isNullOrEmpty == true) || this == "null")
      ? 0.0
      : (double.tryParse("$this") ?? 0.0);

  bool contain(String input, {bool ignoreCase = true}) {
    return isNotNullOrEmpty
        ? ignoreCase
            ? toNotNull.toLowerCase().contains(input.toLowerCase())
            : toNotNull.contains(input.toNotNull)
        : false;

  }

  String truncateTo({int maxLength = 250}) => (toNotNull.length <= maxLength) ? toNotNull : '${toNotNull.substring(0, maxLength)}...';

  String get toBearer => (isNotNullOrEmpty ? "Bearer $this" : this) ?? "";

  bool get isValidEmail => (isNotNullOrEmpty
      ? RegExp(
              r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch("$this")
      : false);

  bool get isValidContact => (isNotNullOrEmpty
      ? RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch("$this")
      : false);

  File? get toFile => isNotNullOrEmpty ? File(toNotNull) : null;

  String? get stripeCurrencySymbol =>
      isNotNullOrEmpty ? this?.replaceAll("₹", "").replaceAll(",", "") : "";

  TimeOfDay? toTimeOfDay({String? inputFormat = "hh:mm a"}) {
    assert(isNotNullOrEmpty, "Input must not be null or empty");
    return TimeOfDay.fromDateTime(DateFormat(inputFormat).parse(toNotNull));
  }

  ///"2023-02-14T07:59:34"
  DateTime? toConvert({String? format = "yyyy-MM-ddTHH:mm:ss"}) {
    return isNotNullOrEmpty
        ? DateFormat(format.toNotNull).parse(toNotNull)
        : null;
  }

  String? toHHMM() {
    if (isNotNullOrEmpty) {
      var time = Time.fromStr(toNotNull);
      return "${(time?.hour ?? 0).toFormat()}:${(time?.minute ?? 0).toFormat()}";
    } else {
      return "";
    }
  }

  Time? toHourTime({bool withSec = true}) {
    try {
      if (isNotNullOrEmpty) {
        return Time.fromStr(toNotNull);
      } else {
        return Time.fromSeconds(0);
      }
    } catch (_) {
      return Time.fromSeconds(0);
    }
  }

  bool get isTimeZero => (Time.fromStr(toNotNull) == Time.fromSeconds(0));

  Duration toDuration() {
    if (isNotNullOrEmpty) {
      var convert = DateFormat("hh:mm:ss").parseUTC(toNotNull);
      return Duration(
          days: convert.day,
          hours: convert.hour,
          minutes: convert.minute,
          seconds: convert.second,
          milliseconds: convert.millisecond,
          microseconds: convert.microsecond);
    } else {
      return const Duration();
    }
  }

  String get stripeNull => isNotNullOrEmpty
      ? "${this?.replaceAll("null", "").replaceAll(r'null', "")}".toNotNull
      : "";

  List<String> splitter({required String? pattern}) {
    if (this?.contains(pattern.toNotNull) ?? false) {
      return toNotNull.split(pattern.toNotNull);
    } else {
      return [toNotNull];
    }
  }

  bool get isNumeric {
    final RegExp regExp = RegExp(r'[^0-9]');
    return regExp.hasMatch(toNotNull);
  }

  bool get isNotNumeric {
    final RegExp regExp = RegExp(r'[a-zA-Z]+$');
    return regExp.hasMatch(toNotNull);
  }
}

extension ListManipulation on List? {
  bool get isNullOrEmpty => (this == null || this?.isEmpty == true);

  bool get isNotNullOrEmpty => (this != null && this?.isNotEmpty == true);

  double? get sumDouble {
    double? sum;
    for (var item in this ?? []) {
      sum = (sum ?? 0) + (double.tryParse("$item") ?? 0);
    }
    return sum;
  }
}

extension IntManipulation on int? {
  bool get asBool => this == 1 ? true : false;

  bool get isNotZero =>
      this != null && this != 0 && !(this?.isNegative == true);

  bool get isZero => this == null || this == 0 || (this?.isNegative == true);
}

extension SizeManipulation on num {
  SizedBox get height => SizedBox(height: toDouble());

  SizedBox get width => SizedBox(width: toDouble());

  EdgeInsets get padding => EdgeInsets.all(toDouble());

  EdgeInsets get leftPadding => EdgeInsets.only(left: toDouble());

  EdgeInsets get rightPadding => EdgeInsets.only(right: toDouble());

  EdgeInsets get topPadding => EdgeInsets.only(top: toDouble());

  EdgeInsets get bottomPadding => EdgeInsets.only(bottom: toDouble());

  EdgeInsets get topBottomInsets =>
      EdgeInsets.only(bottom: toDouble(), top: toDouble());

  EdgeInsets get leftRightInsets =>
      EdgeInsets.only(left: toDouble(), right: toDouble());

  EdgeInsets get topRightInsets =>
      EdgeInsets.only(top: toDouble(), right: toDouble());

  EdgeInsets get topLeftInsets =>
      EdgeInsets.only(top: toDouble(), left: toDouble());

  EdgeInsets get bottomRightInsets =>
      EdgeInsets.only(bottom: toDouble(), right: toDouble());

  EdgeInsets get bottomLeftInsets =>
      EdgeInsets.only(bottom: toDouble(), left: toDouble());

  String toFormat({String pattern = "00"}) =>
      NumberFormat(pattern).format(this);
}

extension TextEditingManipulation on TextEditingController {
  bool get isNullOrEmpty => text.isNullOrEmpty;

  bool get isNotNullOrEmpty => text.isNotNullOrEmpty;

  bool get isValidEmail => text.isNotNullOrEmpty && text.isValidEmail;

  bool get isValidMobile => text.isNotNullOrEmpty && text.isValidContact;
}

extension PrintManipulation on dynamic {
  void get error => Logger(UniqueKey().toString()).severe(this);

  void get warn => debugPrint("$this");

  void get info => Logger(UniqueKey().toString()).info(this);

  String get currencyFormat => (this != null &&
          "$this".isNotNullOrEmpty &&
          (double.tryParse("$this")?.isNegative != true))
      ? "₹ ${NumberFormat("#,##0.00", 'en-IN').format(double.tryParse(this))}"
      : "";

  String get toCurrency =>
      CurrencyTextInputFormatter(symbol: "₹ ").format("$this");

  File? bytesToFile(Uint8List? bytes) =>
      bytes != null ? File.fromRawPath(bytes) : null;

  String? toINR({bool? symbolRequired = false}) {
    var amountDigit = "";
    if (!(symbolRequired ?? false)) {
      amountDigit = Number("$this").toLocaleString('en-IN',
          {"currency": 'INR', "style": 'currency'}).replaceAll(r"/₹/g", "");
    } else {
      amountDigit = Number("$this")
          .toLocaleString('en-IN', {"currency": 'INR', "style": 'currency'});
    }
    return amountDigit;
  }
}

extension ListUtils<T> on List<T> {
  num sumBy(num Function(T element) f) {
    num sum = 0;
    for (var item in this) {
      sum += f(item);
    }
    return sum;
  }
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    // ignore: prefer_collection_literals
    final ids = Set();
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }

  List<E> distinct([Id Function(E element)? id, bool inplace = true]) {
    List<E> list = List.from(this);
    list.unique(id, inplace);
    return list;
  }
}

extension DateConversion on DateTime? {
  String toDate({String? dateFormat}) {
    return dateFormat.isNullOrEmpty
        ? this?.toIso8601String() ?? ""
        : DateFormat(dateFormat).format(this ?? DateTime.now());
  }

  DateTime onlyDate({String? format}) {
    return DateFormat(format).parse(toDate(dateFormat: format));
  }

  bool isAfterNullSafety(DateTime? input) {
    if (input != null) {
      return (this?.isAfter(input) ?? false);
    } else {
      log("Input After: Date is empty or null");
      return false;
    }
  }

  bool isBeforeNullSafety(DateTime? input) {
    if (input != null) {
      return (this?.isBefore(input) ?? false);
    } else {
      log("Input Before: Date is empty or null");
      return false;
    }
  }

  Time toTime({bool withSec = true}) {
    return Time(
        hour: (this?.toLocal().hour ?? 0),
        minute: (this?.toLocal().minute ?? 0),
        second: (withSec == true)
            ? (this?.toLocal().second ?? 0).toFormat().toZero
            : 00);
  }

  bool get isCurrentDate {
    if (this == null) {
      return false;
    }
    var inputDate = this?.toLocal().onlyDate(format: DF.NORMAL_DATE);
    var current = DateTime.now().toLocal().onlyDate(format: DF.NORMAL_DATE);
    return inputDate == current;
  }
}

extension TimeConversion on TimeOfDay? {
  String toIso({String? timeFormat = "hh:mm a"}) {
    return DateFormat(timeFormat)
        .format(DateFormat("HH:mm").parse("${this?.hour}:${this?.minute}"));
  }
}

extension MapData on Map {
  find(Object? key) {
    return containsKey(key) ? this[key] : null;
  }

  findArray(Object? key) {
    return (containsKey(key) && this[key] != null) ? this[key] : [];
  }

  DateTime? findAsDateTime(Object? key) {
    return containsKey(key) ? DateTime.tryParse(this[key].toString()) : null;
  }
}

extension StyleSize on BuildContext {
  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  void get closeDialog => Navigator.of(this).pop('dialog');

  bool get isDialogShowing {
    final currentRoute = ModalRoute.of(this);
    return currentRoute?.isCurrent == true && currentRoute?.canPop == true;
  }

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

}

extension Contexter on BuildContext? {
  void let(Function(BuildContext val) callBack) {
    var context = this;
    if (context != null) {
      callBack.call(context);
    }
  }
}

extension StreamExtensions<T> on Stream<T> {
  ValueListenable<T> toValueNotifier(
    T initialValue, {
    bool Function(T previous, T current)? notifyWhen,
  }) {
    final notifier = ValueNotifier<T>(initialValue);
    listen((value) {
      if (notifyWhen == null || notifyWhen(notifier.value, value)) {
        notifier.value = value;
      }
    });
    return notifier;
  }

  // Edit: added nullable version
  ValueListenable<T?> toNullableValueNotifier(
      {bool Function(T? previous, T? current)? notifyWhen}) {
    final notifier = ValueNotifier<T?>(null);
    listen((value) {
      if (notifyWhen == null || notifyWhen(notifier.value, value)) {
        notifier.value = value;
      }
    });
    return notifier;
  }

  Listenable toListenable() {
    final notifier = ChangeNotifier();
    listen((_) {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      notifier.notifyListeners();
    });
    return notifier;
  }
}

extension DurationExtension on Duration {
  String get diff {
    return "${inHours.toFormat()}:${inMinutes.remainder(60).toFormat()}:${inSeconds.remainder(60).toFormat()}";
  }
}

extension TimeExtension on Time? {
  DateTime? convertToDate({required DateTime? date}) {
    if (this == null || date == null) {
      return null;
    }
    var dateTime = "${date.day}-${date.month}-${date.year} ${this?.hour}:${this?.minute}:${this?.second}";
    return DateFormat("dd-MM-yyyy HH:mm:ss").parse(dateTime);
  }
  String get toHMS =>
      "${this?.hour.toFormat()}:${this?.minute.toFormat()}:${this?.second.toFormat()}";

  bool? isEqualTo(Time? inputTime) {
    if (this == null && inputTime == null) {
      return false;
    }
    return inputTime == this;
  }

  bool? isAfterTo(Time? inputTime) {
    if (this == null && inputTime == null) {
      return false;
    }
    return (this?.isAfter(inputTime!) ?? false);
  }

  bool? isBeforeTo(Time? inputTime) {
    if (this == null && inputTime == null) {
      return false;
    }
    return (this?.isBefore(inputTime!) ?? false);
  }

  bool? isAfterOrEqualTo(Time? inputTime) {
    if (this != null && inputTime != null) {
      final isAtSameMomentAs = inputTime == this;
      return isAtSameMomentAs | (this?.isAfter(inputTime) ?? false);
    }
    return null;
  }

  bool? isBeforeOrEqualTo(Time? inputTime) {
    if (this != null && inputTime != null) {
      final isAtSameMomentAs = inputTime == this;
      return isAtSameMomentAs | (this?.isBefore(inputTime) ?? false);
    }
    return null;
  }

  bool? isBetween({
    required Time? fromTime,
    required Time? toTime,
  }) {
    final time = this;
    if (time != null) {
      final isAfter = time.isAfterOrEqualTo(fromTime) ?? false;
      final isBefore = time.isBeforeOrEqualTo(toTime) ?? false;
      return isAfter && isBefore;
    }
    return null;
  }
}
