import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

class HotKeyUtils {

  // [PRIVATE-MODE-KEY] will help to activate / deactivate Private Mode even app is in background
  static HotKey get privateModeKey  {
    if (Platform.isMacOS) {
      return HotKey(KeyCode.keyP, identifier: "private_mode", modifiers: [KeyModifier.meta, KeyModifier.shift], scope: HotKeyScope.system);
    } else {
      return HotKey(KeyCode.keyP, identifier: "private_mode", modifiers: [KeyModifier.control, KeyModifier.shift], scope: HotKeyScope.system);
    }
  }

  // [VIEW-SCREEN-KEY] will help to [VIEW SCREENS] for selected user
  // To select user need to hover / click the user row
  static HotKey get viewScreenKey  {
   if (Platform.isMacOS) {
     return HotKey(KeyCode.keyS, identifier: "view_screens", modifiers: [KeyModifier.meta], scope: HotKeyScope.inapp);
   } else {
     return HotKey(KeyCode.keyS, identifier: "view_screens", modifiers: [KeyModifier.control], scope: HotKeyScope.inapp);
   }
  }

  // [SEND-MESSAGE-KEY] will help to [SEND DIRECT MESSAGE] for selected user
  // To select user need to hover / click the user row
  static HotKey get sendMessageKey {
    if (Platform.isMacOS) {
      return HotKey(KeyCode.keyM, identifier: "send_direct_message", modifiers: [KeyModifier.meta], scope: HotKeyScope.inapp);
    } else {
      return HotKey(KeyCode.keyM, identifier: "send_direct_message", modifiers: [KeyModifier.control], scope: HotKeyScope.inapp);
    }
  }

  // [ALERT-ONLINE-KEY] will help to [ALERT USER ONLINE] for selected user
  // To select user need to hover / click the user row
  static HotKey get alertOnlineKey {
    if (Platform.isMacOS) {
      return HotKey(KeyCode.keyA, identifier: "alert_online", modifiers: [KeyModifier.meta], scope: HotKeyScope.inapp);
    } else {
      return HotKey(KeyCode.keyA, identifier: "alert_online", modifiers: [KeyModifier.control], scope: HotKeyScope.inapp);
    }
  }

  // [USER-INFO-KEY] will help to [USER INFO] for selected user
  // To select user need to hover / click the user row
  static HotKey get userInfoKey {
    if (Platform.isMacOS) {
      return HotKey(KeyCode.keyI, identifier: "user_info", modifiers: [KeyModifier.meta], scope: HotKeyScope.inapp);
    } else {
      return HotKey(KeyCode.keyI, identifier: "user_info", modifiers: [KeyModifier.control], scope: HotKeyScope.inapp);
    }
  }

  Function(HotKey)? _onKey;
  Function(HotKey)? _onUpKey;

  static String get viewScreenHotKey {
    HotKey key = viewScreenKey;
    return "${key.modifiers?.lastOrNull?.keyLabel} + ${key.keyCode.keyLabel}".toNotNull;
  }

  static String get sendMessageHotKey {
    HotKey key = sendMessageKey;
    return "${key.modifiers?.lastOrNull?.keyLabel} + ${key.keyCode.keyLabel}".toNotNull;
  }

  static String get alertOnlineHotKey {
    HotKey key = alertOnlineKey;
    return "${key.modifiers?.lastOrNull?.keyLabel} + ${key.keyCode.keyLabel}".toNotNull;
  }

  static String get userInfoHotKey {
    HotKey key = userInfoKey;
    return "${key.modifiers?.lastOrNull?.keyLabel} + ${key.keyCode.keyLabel}".toNotNull;
  }

  // [REGISTER] to register any [HotKey] with this help it'll work
  void register({required HotKey key}) async => await hotKeyManager.register(key, keyDownHandler: (hotKey) => _onKey?.call(hotKey), keyUpHandler: (hotKey) => _onUpKey?.call(hotKey));

  // [KEYDOWN] function result only emit from here
  void onChange(Function(HotKey) onChange) => _onKey = onChange;

  // [KEYUP] function result only emit from here
  void onUpdate(Function(HotKey) onChange) => _onUpKey = onChange;

  // [UNREGISTER] it'll unregister all the registered keys
  static void unregisterAll() async => await hotKeyManager.unregisterAll();

  // [UNREGISTER] it'll unregister given key
  static void unregister(HotKey key) async => await hotKeyManager.unregister(key);
}