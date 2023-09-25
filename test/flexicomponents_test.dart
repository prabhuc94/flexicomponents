import 'package:flutter_test/flutter_test.dart';
import 'package:flexicomponents/flexicomponents.dart';
import 'package:flexicomponents/flexicomponents_platform_interface.dart';
import 'package:flexicomponents/flexicomponents_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlexicomponentsPlatform
    with MockPlatformInterfaceMixin
    implements FlexicomponentsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlexicomponentsPlatform initialPlatform = FlexicomponentsPlatform.instance;

  test('$MethodChannelFlexicomponents is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlexicomponents>());
  });

  test('getPlatformVersion', () async {
    Flexicomponents flexicomponentsPlugin = Flexicomponents();
    MockFlexicomponentsPlatform fakePlatform = MockFlexicomponentsPlatform();
    FlexicomponentsPlatform.instance = fakePlatform;

    expect(await flexicomponentsPlugin.getPlatformVersion(), '42');
  });
}
