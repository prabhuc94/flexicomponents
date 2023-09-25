
import 'flexicomponents_platform_interface.dart';

class Flexicomponents {
  Future<String?> getPlatformVersion() {
    return FlexicomponentsPlatform.instance.getPlatformVersion();
  }
}
