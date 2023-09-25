import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flexicomponents_platform_interface.dart';

/// An implementation of [FlexicomponentsPlatform] that uses method channels.
class MethodChannelFlexicomponents extends FlexicomponentsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flexicomponents');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
