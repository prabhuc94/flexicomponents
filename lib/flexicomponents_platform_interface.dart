import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flexicomponents_method_channel.dart';

abstract class FlexicomponentsPlatform extends PlatformInterface {
  /// Constructs a FlexicomponentsPlatform.
  FlexicomponentsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlexicomponentsPlatform _instance = MethodChannelFlexicomponents();

  /// The default instance of [FlexicomponentsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlexicomponents].
  static FlexicomponentsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlexicomponentsPlatform] when
  /// they register themselves.
  static set instance(FlexicomponentsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
